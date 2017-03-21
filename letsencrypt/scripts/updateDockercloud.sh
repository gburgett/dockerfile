#! /bin/bash

[[ -z "$DOCKERCLOUD_AUTH" ]] && echo "no DOCKERCLOUD_AUTH, exiting" && exit -1;

# get all the dockercloud.key files that we need to upload to dockercloud's api
KEYS=`find ~/.acme.sh/ -name dockercloud.key`

while read -r keyfile; do
    # pull the name of the directory that the file is in, replacing dots with dashes to get the service name
    servicename=`dirname "$keyfile" | xargs basename | sed 's/\./-/g'`

    serviceid=`curl -H "Authorization: $DOCKERCLOUD_AUTH" https://cloud.docker.com/api/app/v1/service/?name=$servicename | jq -r '.objects[].uuid'`

    [[ -z "$serviceid" ]] && echo "service $servicename doesnt exist" && continue;

    # get the current environment variables and replace the correct one with the new cert value
    service=`curl -H "Authorization: $DOCKERCLOUD_AUTH" https://cloud.docker.com/api/app/v1/service/$serviceid/`
    cert=`cat $keyfile`
    envvars=`echo $service | jq -r ".container_envvars | map(if (.key == \"SSL_CERT\") then . + { \"value\": \"$cert\" } else . end)"`

    curl -H "Authorization: $DOCKERCLOUD_AUTH" \
         -H "Content-Type: application/json"  \
         --request PATCH \
         -d "{\"container_envvars\": $envvars }" \
         https://cloud.docker.com/api/app/v1/service/$serviceid/ 

    echo "\npatched service $servicename, redeploying..."
    curl -H "Authorization: $DOCKERCLOUD_AUTH" -XPOST https://cloud.docker.com/api/app/v1/service/$serviceid/redeploy/

done <<< "$KEYS"

echo "please restart the load balancer"