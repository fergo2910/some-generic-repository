# stdlib
import json
import sys


if len(sys.argv) < 3:
    raise Exception(
        "Usage: heroku-promote-payload.py\
         <PIPELINE_ID> <APP_ID> <PROD_TARGETS>"
    )

payload = {
    "pipeline": {"id": sys.argv[1]},
    "source": {"app": {"id": sys.argv[2]}},
    "targets": [],
}

for target in sys.argv[3:]:
    payload.get("targets").append({"app": {"id": target}})

print(json.dumps(payload))
