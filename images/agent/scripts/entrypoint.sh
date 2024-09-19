#!/bin/bash
RUNNER_TOKEN=$1
RUNNER_NAME=${2:-$(hostname)}

./config.sh \
  --url https://github.com/aethen22org \
  --token $RUNNER_TOKEN \
  --name $RUNNER_NAME \
  --work _work \
  --unattended \
  --replace

exec /home/agent/bin/runsvc.sh
