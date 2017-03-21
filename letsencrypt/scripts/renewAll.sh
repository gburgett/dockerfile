#! /bin/bash

set -e

[[ -z "$S3_BUCKET" ]] && echo "s3 bucket not set, exiting" && exit -1;

acme.sh --renewAll

# find all directories which correspond to domains
DOMAINS=`find ~/.acme.sh/ -maxdepth 1 -mindepth 1 -type d | grep '\.[^/]\{2,\}$'`

while read -r path; do
    domain=`basename $path`

    # combine the certificate with the private key
    cat $path/fullchain.cer $path/$domain.key  > $path/dockercloud.key
    # replace newlines with the literal newline character as required by dockercloud
    sed -i ':a;N;$!ba;s/\n/\\n/g' $path/dockercloud.key

    echo "built $path/dockercloud.key"
done <<< "$DOMAINS"