#!/bin/bash

GH_TOKEN=$1
GH_REPO=$2
GH_SHA=$3

curl -fsS "https://api.github.com/repos/$GH_REPO/tarball/$GH_SHA" \
    -H "Authorization: token $GH_TOKEN"  -D - -o /dev/null | awk -v RS='\r\n' -v OFS='' -F'location: ' '$2 {print $2}'
