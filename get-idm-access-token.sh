#!/bin/bash

#
# Copyright 2021 ForgeRock AS. All Rights Reserved
#

AM_URL=$1
AMADMIN=$2
AMADMIN_PASS=$3
CLIENT_ID=idm-admin-client
CLIENT_SECRET=password

# Get access token
TOKENS=`curl --request POST "$AM_URL/oauth2/access_token" \
 --header "Content-Type: application/x-www-form-urlencoded" \
 --data-urlencode "grant_type=password" \
 --data-urlencode "client_id=$CLIENT_ID" \
 --data-urlencode "client_secret=$CLIENT_SECRET" \
 --data-urlencode "username=$AMADMIN" \
 --data-urlencode "password=$AMADMIN_PASS" \
 --data-urlencode "scope=fr:idm:*" | jq .`

ACCESS_TOKEN=`echo $TOKENS | jq -r .access_token`
echo "$ACCESS_TOKEN"