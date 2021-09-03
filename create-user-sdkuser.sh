#!/bin/bash

#
# Copyright 2021 ForgeRock AS. All Rights Reserved
#

AM_URL=$1
AMADMIN=$2
AMADMIN_PASS=$3
BASE_HOST="${AM_URL%/*}"
IDM_URL=$BASE_HOST/openidm
ACCESS_TOKEN=$(./get-idm-access-token.sh $AM_URL $AMADMIN $AMADMIN_PASS)

echo "ACCESS_TOKEN: $ACCESS_TOKEN"

# Create a test user (sdkuser) and password 'password'
curl \
--header "Content-Type: application/json" \
--header "Authorization: Bearer $ACCESS_TOKEN" \
--header "Accept-API-Version: resource=1.0" \
--request POST \
--data '{
  "userName": "sdkuser",
  "sn": "User",
  "givenName": "Sdk",
  "mail": "sdkuser@example.com",
  "password": "password"
}' \
"$IDM_URL/managed/user?_action=create" --insecure