#! /bin/bash

set -e

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

# Ensure we don't overwrite a backup for a different instance
[[ ! -e "$INSTALL_DIR/config/config.php" ]] && echo "cannot backup uninitialized install $INSTALL_DIR" && exit -1

# check instanceID against s3
instanceid=`cat $INSTALL_DIR/config/config.php | grep instanceid | sed "s/.*'instanceid' => '\([a-zA-Z0-9]*\)'.*/\1/"`
[[ -z "$instanceid" ]] && echo "cannot backup uninitialized install $INSTALL_DIR" && exit -1

if [[ "$force" = false ]]; then
  # copy the remote config.php, but if it doesn't exist then we'll backup over the empty bucket
  aws s3 cp $AWS_S3_BUCKET/config/config.php /tmp/config.php || force=true
  if [[ "$force" = false ]]; then
    instanceid_bak=`cat /tmp/config.php | grep instanceid | sed "s/.*'instanceid' => '\([a-zA-Z0-9]*\)'.*/\1/"`

    if [[ "$instanceid" != "$instanceid_bak" ]]; then
      echo "cannot backup local install ($instanceid) over backup install ($instanceid_bak)"
      exit -1
    fi
  fi
fi

echo "backing up instance $instanceid to s3 bucket $AWS_S3_BUCKET"

# backup and upload database
[[ ! -d "/tmp/db" ]] && mkdir /tmp/db
sqlite3 $INSTALL_DIR/data/owncloud.db .dump | gzip > /tmp/db/owncloud.bak.gz
aws s3 sync /tmp/db/ $AWS_S3_BUCKET/db/ --delete

# backup and upload config & data
aws s3 sync $INSTALL_DIR/config $AWS_S3_BUCKET/config --delete
aws s3 sync $INSTALL_DIR/data $AWS_S3_BUCKET/data --exclude "owncloud.*" --delete
