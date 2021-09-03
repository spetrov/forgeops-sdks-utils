#!/usr/bin/env bash

# Make sure the script runs from the directory it is located in...
cd "$(dirname "$0")"

AM_URL=$1
AMADMIN=$2
AMADMIN_PASS=$3

# Get a session token
TOKEN=$(curl -X POST \
  -H 'accept-api-version: resource=2.0,protocol=1.0' \
  -H 'accept: application/json' \
  -H 'x-openam-username: '"$AMADMIN"'' \
  -H 'x-openam-password: '"$AMADMIN_PASS"'' \
  -H 'x-requested-with: curl' \
  $AM_URL/json/realms/root/authenticate --insecure | jq -r '.tokenId')

echo "Session token: $TOKEN"

# Set CORS (js-cors)
./set-cors.sh $AM_URL $TOKEN

# Create OAuth client WebOauthClient
./create-oauth-client-WebOauthClient.sh $AM_URL $TOKEN

# Create OAuth client iosclient
./create-oauth-client-iosclient.sh $AM_URL $TOKEN

# Create OAuth client AndroidTest
./create-oauth-client-AndroidTest.sh $AM_URL $TOKEN

# Create OAuth client idm-admin-client
./create-oauth-client-idm-admin-client.sh $AM_URL $TOKEN

# Import all test trees in the 'sdks-trees' directory
cd "sdks-trees/"
../AM-treetool/amtree.sh -h $AM_URL -u $AMADMIN -p $AMADMIN_PASS -s
cd "../"

# Create user to user mapping
./create-user-to-user-mapping.sh $AM_URL $AMADMIN $AMADMIN_PASS

# Update manged user object - no password restrictions, and adding age (number) property
./update-managed-user-object.sh $AM_URL $AMADMIN $AMADMIN_PASS

# Create test user 'sdkuser' with password 'password'
sleep 5
./create-user-sdkuser.sh $AM_URL $AMADMIN $AMADMIN_PASS