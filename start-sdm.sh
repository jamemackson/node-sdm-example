#!/bin/bash
# logs into sdm
echo 'debugging sdm token'
echo $SDM_ADMIN_TOKEN | sed 's/./& /g'
echo "sdm logging in..."
sdm login --admin-token $SDM_ADMIN_TOKEN
echo "sdm updating..."
# updates to latest release
sdm update
echo "sdm starting..."
# starts listener manually
sdm listen --daemon &
# attempts sdm status until successful
until sdm ready &> /dev/null;
do
  sleep 1
  echo "waiting for SDM to start..."
done
echo "SDM has started."
# show sdm status
sdm status
