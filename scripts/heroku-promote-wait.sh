#!/bin/bash

HEROKU_TOKEN=$1
PROMOTE_ID=$2

n=1
while true
do
    promotion_status=$(curl -s -n https://api.heroku.com/pipeline-promotions/"$PROMOTE_ID" \
        -H "Content-Type: application/json" \
        -H "Accept: application/vnd.heroku+json; version=3" \
        -H "Authorization: Bearer ${HEROKU_TOKEN}" | jq -r .status )
    
    if [[ "$promotion_status" == "pending" ]]; then
        echo "waiting for promotion to change status..."
    else
        echo "status transitioned to $promotion_status"
        echo ::set-output name=promotion_status::$promotion_status
        break
    fi
    if [[ $n -gt 30 ]]; then
        echo "timeout"
        exit 1
    fi
    ((n++))
    
    sleep 10
done
