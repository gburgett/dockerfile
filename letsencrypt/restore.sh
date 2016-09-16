#!/bin/bash

aws s3 sync $S3_BUCKET .acme.sh/
