#!/bin/bash

[[ -z "$S3_BUCKET" ]] && echo "s3 bucket not set, exiting" && exit -1;

aws s3 sync $S3_BUCKET /root/.acme.sh/
