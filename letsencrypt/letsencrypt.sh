#! /bin/bash

USAGE='letsencrypt [OPTIONS] [COMMAND] [SERVICE]
Manages certificates for a given docker cloud service.
The service must specify the "" environment variable.
The service will be de-linked from the dockercloud/haproxy
load balancer while the operation is performed.

When finished, the certificate information will be uploaded
to the docker cloud API, in the SSL_CERT envrionment variable.

OPTIONS
-h, --help      Prints this usage

COMMANDS
create          Creates a new certificate for the domain
                 specified in the environment variable
renew           Renews a certificate for the domain
                 specified in the environment variable
help            Prints this usage
'

while getopts "h" opt; do
  case $opt in
     h) echo "USAGE: $USAGE"; exit 0 ;;
     \?) echo "Invalid option: -$OPTARG" >&2; echo "USAGE: $USAGE"; exit -1;;
 esac
done
shift $((OPTIND-1))

cmd=$1
shift

[[ -z "$cmd" ]] && echo "command cannot be empty" >&2 && echo "USAGE: $USAGE" && exit -1;
case $cmd in
    create) ;;
    renew) ;;
	help) echo "USAGE: $USAGE"; exit 0 ;;
    *) echo "Invalid command: $cmd" >&2; echo "USAGE: $USAGE"; exit -1;;
esac


echo "command: $cmd, remaining: $@"

function create() {
	echo "Creating $1"
}


function renew() {
	echo "Renewing"
}


case $cmd in
    create) 
		create $@
		;;
    renew) 
		renew $@
esac