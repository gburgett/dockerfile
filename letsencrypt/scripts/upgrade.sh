#! /bin/bash

[[ -z "$S3_BUCKET" ]] && echo "s3 bucket not set, exiting" && exit -1;

restore.sh
acme.sh --upgrade
backup.sh