#!/bin/bash

aws s3 sync /root/.acme.sh/ $S3_BUCKET  --exclude "acme.*" --exclude "dnsapi*" --delete
