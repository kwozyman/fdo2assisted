#!/bin/bash

PULL_SECRET=$(cat "$1" | jq -r  '.systemd.units[] | select(.name=="agent.service").contents' | grep PULL_SECRET_TOKEN | awk -F'Environment=PULL_SECRET_TOKEN=' '{print $2}')
echo PULL_SECRET_TOKEN="${PULL_SECRET}" > .secrets
cat "$1" | jq -r  '.systemd.units[] | select(.name=="agent.service").contents' | grep ExecStart | sed 's/ExecStartPre=//g' | sed 's/ExecStart=//g' >> .secrets

