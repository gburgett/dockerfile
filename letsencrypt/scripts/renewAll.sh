#! /bin/bash

[[ -z "$S3_BUCKET" ]] && echo "s3 bucket not set, exiting" && exit -1;

[[ ! -d ~/.acme.sh/ ]] && echo "restoring from s3" && ./restore.sh

# find all directories which correspond to domains & list them so we can see what changed
DOMAINS=`find ~/.acme.sh/ -maxdepth 1 -mindepth 1 -type d | grep '\.[^/]\{2,\}$'`
if [[ -z "$DOMAINS" ]]; then
    echo "restoring from s3"
    ./restore.sh

    DOMAINS=`find ~/.acme.sh/ -maxdepth 1 -mindepth 1 -type d | grep '\.[^/]\{2,\}$'`
    [[ -z "$DOMAINS" ]] && echo "error restoring from bucket $S3_BUCKET" && exit -1;
fi

set -e

declare -A stats
while read -r path; do
    domain=`basename $path`

    stats[$domain]=`ls -l $path`
done <<< "$DOMAINS"

acme.sh --renewAll

# find all domains again and compare
DOMAINS=`find ~/.acme.sh/ -maxdepth 1 -mindepth 1 -type d | grep '\.[^/]\{2,\}$'`

while read -r path; do
    domain=`basename $path`

    # nothing changed, skip creating the dockercloud file
    [[ "${stats[$domain]}" == "`ls -l $path`" ]] && continue;

    # combine the certificate with the private key
    cat $path/fullchain.cer $path/$domain.key  > $path/dockercloud.key
    # replace newlines with the literal newline character as required by dockercloud
    sed -i ':a;N;$!ba;s/\n/\\n/g' $path/dockercloud.key

    echo "built $path/dockercloud.key"
done <<< "$DOMAINS"
