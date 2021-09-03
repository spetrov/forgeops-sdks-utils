#!/bin/bash

#
# Copyright 2021 ForgeRock AS. All Rights Reserved
#

AM_URL=$1
TOKEN=$2

# Set CORS
curl -X PUT \
  -H 'iPlanetDirectoryPro: '"$TOKEN"'' \
  -H 'content-type: application/json' \
  -H 'x-requested-with: curl' \
  -d '{
    "acceptedOrigins": [
        "https://sdkapp.example.com:8443"
    ],
    "acceptedMethods": [
        "GET",
        "POST"
    ],
    "allowCredentials": true,
    "maxAge": 0,
    "enabled": true,
    "acceptedHeaders": [
        "Content-Type",
        "X-Requested-With",
        "Accept-API-Version",
        "If-Match",
        "Authorization"
    ],
    "exposedHeaders": [],
    "_type": {
        "_id": "configuration",
        "name": "Cors Configuration",
        "collection": true
    }
}' \
  $AM_URL/json/global-config/services/CorsService/configuration/js-sdk --insecure