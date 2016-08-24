This container should be run with --volumes-from to attach it to the owncloud container. Then execute "/backup.sh" or "/restore.sh" to synchronize owncloud data to s3.

required environment variables:

* AWS_ACCESS_KEY_ID
* AWS_SECRET_KEY_ID

usage:
    backup.sh [-f] S3_URL [INSTALL_DIR]
      dumps the sqlite database and syncs all data and config files to amazon s3

      -f - force the backup to happen (normally will refuse to back up if the config.php file on s3 contains a different instanceid)
      S3_URL - the URL of the s3 bucket to upload to, ex. s3://mybucket/backup/owncloud
      INSTALL_DIR - the optional alternate location of the owncloud installation directory if not /var/www/html


    restore.sh [-f] S3_URL [INSTALL_DIR]
      restores the sqlite database and syncs all data and config files from amazon s3

      -f - force the restore to happen (normally will refuse to restore if the config.php file on s3 contains the same instanceid - meaning the backup on s3 is stale)
      S3_URL - the URL of the s3 bucket to download from, ex. s3://mybucket/backup/owncloud
      INSTALL_DIR - the optional alternate location of the owncloud installation directory if not /var/www/html
