#!/bin/bash

[[ -z "$AWS_ACCESS_KEY_ID" ]] && \
  echo "No AWS credentials set - please set environment variable AWS_ACCESS_KEY_ID" && \
  exit -1

[[ -z "$AWS_SECRET_ACCESS_KEY" ]] && \
  echo "No AWS credentials set - please set environment variable AWS_SECRET_ACCESS_KEY" && \
  exit -1

# ensure the AWS environment variables are copied to the right spot,
# b/c cron doesn't load envvars
[[ ! -d ~/.aws ]] && mkdir ~/.aws

cat > ~/.aws/credentials << EOM
[default]
aws_access_key_id=$AWS_ACCESS_KEY_ID
aws_secret_access_key=$AWS_SECRET_ACCESS_KEY
EOM

crond -f
