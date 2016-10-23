#!/bin/bash

aws s3 sync $S3_BUCKET /root/.acme.sh/
