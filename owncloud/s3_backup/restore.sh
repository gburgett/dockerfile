#! /bin/bash

set -ex

force=false
while getopts "h?f" opt; do
    case "$opt" in
    h|\?)
        echo "usage: $0 [-f] [AWS_S3_BUCKET] [INSTALL_DIR]"
        exit 0
        ;;
    f)  force=true
        ;;
    esac
done

shift $((OPTIND-1))

[ "$1" = "--" ] && shift

[[ ! -z "$1" ]] && AWS_S3_BUCKET=$1
[[ -z "$AWS_S3_BUCKET" ]] && echo "no s3 bucket specified - pass as 1st param or set AWS_S3_BUCKET env variable" && echo -1

[[ ! -z "$2" ]] && INSTALL_DIR=$2
[[ -z "$INSTALL_DIR" ]] && INSTALL_DIR="/var/www/html"


if [[ "$force" = false ]]; then
  # check if fresh install
  if [[ -e "$INSTALL_DIR/config/config.php" ]]; then
    # check instanceID against s3
    instanceid=`cat $INSTALL_DIR/config/config.php | grep instanceid | sed "s/.*'instanceid' => '\([a-zA-Z0-9]*\)'.*/\1/"`
    if [[ ! -z "$instanceid" ]]; then
      aws s3 cp $AWS_S3_BUCKET/config/config.php /tmp/config.php
      instanceid_bak=`cat /tmp/config.php | grep instanceid | sed "s/.*'instanceid' => '\([a-zA-Z0-9]*\)'.*/\1/"`

      if [[ "$instanceid" == "$instanceid_bak" ]]; then
        echo "backup on s3 is stale, cannot restore over the same instanceid ($instanceid)"
        exit -1
      fi
    fi
  fi
fi

# restore database
[[ ! -d "/tmp/db" ]] && mkdir /tmp/db
aws s3 sync $AWS_S3_BUCKET/db/ /tmp/db/
[[ ! -d "$INSTALL_DIR/data" ]] && mkdir $INSTALL_DIR/data
rm $INSTALL_DIR/data/owncloud.db || true
gunzip < /tmp/db/owncloud.bak.gz | sqlite3 $INSTALL_DIR/data/owncloud.db

# restore data and config
aws s3 sync $AWS_S3_BUCKET/config $INSTALL_DIR/config
aws s3 sync $AWS_S3_BUCKET/data $INSTALL_DIR/data
