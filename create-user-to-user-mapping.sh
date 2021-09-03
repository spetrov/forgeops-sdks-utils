#!/usr/bin/env bash
AM_URL=$1
AMADMIN=$2
AMADMIN_PASS=$3
BASE_HOST="${AM_URL%/*}"
IDM_URL=$BASE_HOST/openidm
ACCESS_TOKEN=$(./get-idm-access-token.sh $AM_URL $AMADMIN $AMADMIN_PASS)

echo "ACCESS_TOKEN: $ACCESS_TOKEN"

# Create an Identity Mapping
curl \
--header "Content-Type: application/json" \
--header "Authorization: Bearer $ACCESS_TOKEN" \
--header "Accept-API-Version: resource=1.0" \
--request PUT \
--data '{
    "_id": "sync",
    "mappings": [
        {
            "target": "managed/user",
            "source": "managed/user",
            "name": "managedUser_managedUser",
            "consentRequired": true,
            "displayName": "Identity Mapping",
            "properties": [],
            "policies": [
                {
                    "action": "ASYNC",
                    "situation": "ABSENT"
                },
                {
                    "action": "ASYNC",
                    "situation": "ALL_GONE"
                },
                {
                    "action": "ASYNC",
                    "situation": "AMBIGUOUS"
                },
                {
                    "action": "ASYNC",
                    "situation": "CONFIRMED"
                },
                {
                    "action": "ASYNC",
                    "situation": "FOUND"
                },
                {
                    "action": "ASYNC",
                    "situation": "FOUND_ALREADY_LINKED"
                },
                {
                    "action": "ASYNC",
                    "situation": "LINK_ONLY"
                },
                {
                    "action": "ASYNC",
                    "situation": "MISSING"
                },
                {
                    "action": "ASYNC",
                    "situation": "SOURCE_IGNORED"
                },
                {
                    "action": "ASYNC",
                    "situation": "SOURCE_MISSING"
                },
                {
                    "action": "ASYNC",
                    "situation": "TARGET_IGNORED"
                },
                {
                    "action": "ASYNC",
                    "situation": "UNASSIGNED"
                },
                {
                    "action": "ASYNC",
                    "situation": "UNQUALIFIED"
                }
            ]
        }
    ]
}' \
"$IDM_URL/config/sync" --insecure