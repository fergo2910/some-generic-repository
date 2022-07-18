#!/bin/bash

HEROKU_TOKEN=$1
HEROKU_APP=$2
GH_LINK=$3
GH_SHA=$4

PAYLOAD=$( echo '{"source_blob":{}}' \
    | jq ".source_blob.url = \"$GH_LINK\"" \
    | jq ".source_blob.version = \"$GH_SHA\"" 
    )

curl -fsSv -X POST "https://api.heroku.com/apps/$HEROKU_APP/builds" \
                -d "$PAYLOAD" \
                -H "Authorization: Bearer $HEROKU_TOKEN" \
                -H 'Accept: application/vnd.heroku+json; version=3' \
                -H "Content-Type: application/json"
