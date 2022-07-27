#!/bin/bash

HEROKU_TOKEN=$1
PIPELINE_NAME=$2
APP_NAME=$3


APP_ID=$(curl -s -n https://api.heroku.com/apps/"$APP_NAME" \
    -H "Accept: application/vnd.heroku+json; version=3" \
    -H "Authorization: Bearer $HEROKU_TOKEN" | jq -r .id )

PIPELINE_ID=$(curl -s -n https://api.heroku.com/pipelines/"$PIPELINE_NAME" \
    -H "Accept: application/vnd.heroku+json; version=3" \
    -H "Authorization: Bearer $HEROKU_TOKEN" | jq -r .id )

PROD_TARGETS=$(curl -s -n https://api.heroku.com/pipelines/"$PIPELINE_ID"/pipeline-couplings \
  -H "Accept: application/vnd.heroku+json; version=3" \
  -H "Authorization: Bearer $HEROKU_TOKEN" \
  | jq -rc '.[] | select( .stage == "production" ) | .app.id')

PAYLOAD=$(python ./scripts/heroku-promote-payload.py "$PIPELINE_ID" "$APP_ID" "$PROD_TARGETS")

curl -s -n -X POST https://api.heroku.com/pipeline-promotions \
  -d "$PAYLOAD" \
  -H "Content-Type: application/json" \
  -H "Accept: application/vnd.heroku+json; version=3" \
  -H "Authorization: Bearer $HEROKU_TOKEN"
