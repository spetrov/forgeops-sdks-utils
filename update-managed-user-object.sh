#!/usr/bin/env bash
AM_URL=$1
AMADMIN=$2
AMADMIN_PASS=$3
BASE_HOST="${AM_URL%/*}"
IDM_URL=$BASE_HOST/openidm
ACCESS_TOKEN=$(./get-idm-access-token.sh $AM_URL $AMADMIN $AMADMIN_PASS)

echo "ACCESS_TOKEN: $ACCESS_TOKEN"

# Update the manage user object in IDM - no password restrictions, and age (number) property
curl \
--header "Content-Type: application/json" \
--header "Authorization: Bearer $ACCESS_TOKEN" \
--header "Accept-API-Version: resource=1.0" \
--request PUT \
--data '{
    "_id": "managed/user",
    "objects": [
        {
            "name": "user",
            "onUpdate": {
                "type": "text/javascript",
                "source": "require('"'"'onUpdateUser'"'"').preserveLastSync(object, oldObject, request);"
            },
            "schema": {
                "$schema": "http://forgerock.org/json-schema#",
                "type": "object",
                "title": "User",
                "description": null,
                "icon": "fa-user",
                "properties": {
                    "_id": {
                        "description": "User ID",
                        "type": "string",
                        "viewable": false,
                        "searchable": false,
                        "userEditable": false,
                        "usageDescription": null,
                        "isPersonal": false,
                        "policies": [
                            {
                                "policyId": "cannot-contain-characters",
                                "params": {
                                    "forbiddenChars": [
                                        "/"
                                    ]
                                }
                            }
                        ]
                    },
                    "userName": {
                        "title": "Username",
                        "description": "Username",
                        "viewable": true,
                        "type": "string",
                        "searchable": true,
                        "userEditable": true,
                        "usageDescription": null,
                        "isPersonal": true,
                        "policies": [
                            {
                                "policyId": "valid-username"
                            },
                            {
                                "policyId": "cannot-contain-characters",
                                "params": {
                                    "forbiddenChars": [
                                        "/"
                                    ]
                                }
                            },
                            {
                                "policyId": "minimum-length",
                                "params": {
                                    "minLength": 1
                                }
                            },
                            {
                                "policyId": "maximum-length",
                                "params": {
                                    "maxLength": 255
                                }
                            }
                        ]
                    },
                    "password": {
                        "title": "Password",
                        "description": "Password",
                        "type": "string",
                        "viewable": false,
                        "searchable": false,
                        "userEditable": false,
                        "scope": "private",
                        "isProtected": true,
                        "usageDescription": null,
                        "isPersonal": false,
                        "policies": [],
                        "isVirtual": false,
                        "deleteQueryConfig": false
                    },
                    "givenName": {
                        "title": "First Name",
                        "description": "First Name",
                        "viewable": true,
                        "type": "string",
                        "searchable": true,
                        "userEditable": true,
                        "usageDescription": null,
                        "isPersonal": true
                    },
                    "cn": {
                        "title": "Common Name",
                        "description": "Common Name",
                        "type": "string",
                        "viewable": false,
                        "searchable": false,
                        "userEditable": false,
                        "scope": "private",
                        "isPersonal": true,
                        "isVirtual": true,
                        "onStore": {
                            "type": "text/javascript",
                            "source": "object.cn || (object.givenName + '"'"' '"'"' + object.sn)"
                        }
                    },
                    "sn": {
                        "title": "Last Name",
                        "description": "Last Name",
                        "viewable": true,
                        "type": "string",
                        "searchable": true,
                        "userEditable": true,
                        "usageDescription": null,
                        "isPersonal": true
                    },
                    "mail": {
                        "title": "Email Address",
                        "description": "Email Address",
                        "viewable": true,
                        "type": "string",
                        "searchable": true,
                        "userEditable": true,
                        "usageDescription": null,
                        "isPersonal": true,
                        "policies": [
                            {
                                "policyId": "valid-email-address-format"
                            }
                        ]
                    },
                    "profileImage": {
                        "title": "Profile Image",
                        "description": "Profile Image",
                        "viewable": false,
                        "type": "string",
                        "searchable": true,
                        "userEditable": true,
                        "usageDescription": null,
                        "isPersonal": true
                    },
                    "description": {
                        "title": "Description",
                        "description": "Description",
                        "viewable": true,
                        "type": "string",
                        "searchable": true,
                        "userEditable": true,
                        "usageDescription": null,
                        "isPersonal": false
                    },
                    "accountStatus": {
                        "title": "Status",
                        "default": "active",
                        "description": "Status",
                        "viewable": true,
                        "type": "string",
                        "searchable": true,
                        "userEditable": false,
                        "usageDescription": null,
                        "isPersonal": false
                    },
                    "telephoneNumber": {
                        "type": "string",
                        "title": "Telephone Number",
                        "description": "Telephone Number",
                        "viewable": true,
                        "userEditable": true,
                        "pattern": "^\\+?([0-9\\- \\(\\)])*$",
                        "usageDescription": null,
                        "isPersonal": true
                    },
                    "postalAddress": {
                        "type": "string",
                        "title": "Address 1",
                        "description": "Address 1",
                        "viewable": true,
                        "userEditable": true,
                        "usageDescription": null,
                        "isPersonal": true
                    },
                    "city": {
                        "type": "string",
                        "title": "City",
                        "description": "City",
                        "viewable": true,
                        "userEditable": true,
                        "usageDescription": null,
                        "isPersonal": false
                    },
                    "postalCode": {
                        "type": "string",
                        "title": "Postal Code",
                        "description": "Postal Code",
                        "viewable": true,
                        "userEditable": true,
                        "usageDescription": null,
                        "isPersonal": false
                    },
                    "country": {
                        "type": "string",
                        "title": "Country",
                        "description": "Country",
                        "viewable": true,
                        "userEditable": true,
                        "usageDescription": null,
                        "isPersonal": false
                    },
                    "stateProvince": {
                        "type": "string",
                        "title": "State/Province",
                        "description": "State/Province",
                        "viewable": true,
                        "userEditable": true,
                        "usageDescription": null,
                        "isPersonal": false
                    },
                    "assignedDashboard": {
                        "title": "Assigned Dashboard",
                        "description": "List of items to click on for this user",
                        "type": "array",
                        "items": {
                            "type": "string",
                            "title": "Assigned Dashboard Items"
                        },
                        "viewable": true,
                        "searchable": false,
                        "userEditable": false,
                        "isVirtual": false
                    },
                    "roles": {
                        "description": "Provisioning Roles",
                        "title": "Provisioning Roles",
                        "id": "urn:jsonschema:org:forgerock:openidm:managed:api:User:roles",
                        "viewable": true,
                        "userEditable": false,
                        "returnByDefault": false,
                        "usageDescription": null,
                        "isPersonal": false,
                        "type": "array",
                        "relationshipGrantTemporalConstraintsEnforced": true,
                        "items": {
                            "type": "relationship",
                            "id": "urn:jsonschema:org:forgerock:openidm:managed:api:User:roles:items",
                            "title": "Provisioning Roles Items",
                            "reverseRelationship": true,
                            "reversePropertyName": "members",
                            "notifySelf": true,
                            "validate": true,
                            "properties": {
                                "_ref": {
                                    "description": "References a relationship from a managed object",
                                    "type": "string"
                                },
                                "_refProperties": {
                                    "description": "Supports metadata within the relationship",
                                    "type": "object",
                                    "title": "Provisioning Roles Items _refProperties",
                                    "properties": {
                                        "_id": {
                                            "description": "_refProperties object ID",
                                            "type": "string"
                                        },
                                        "_grantType": {
                                            "description": "Grant Type",
                                            "type": "string",
                                            "label": "Grant Type"
                                        }
                                    }
                                }
                            },
                            "resourceCollection": [
                                {
                                    "path": "managed/role",
                                    "label": "Role",
                                    "conditionalAssociationField": "condition",
                                    "query": {
                                        "queryFilter": "true",
                                        "fields": [
                                            "name"
                                        ]
                                    }
                                }
                            ]
                        }
                    },
                    "manager": {
                        "type": "relationship",
                        "validate": true,
                        "reverseRelationship": true,
                        "reversePropertyName": "reports",
                        "description": "Manager",
                        "title": "Manager",
                        "viewable": true,
                        "searchable": false,
                        "usageDescription": null,
                        "isPersonal": false,
                        "properties": {
                            "_ref": {
                                "description": "References a relationship from a managed object",
                                "type": "string"
                            },
                            "_refProperties": {
                                "description": "Supports metadata within the relationship",
                                "type": "object",
                                "title": "Manager _refProperties",
                                "properties": {
                                    "_id": {
                                        "description": "_refProperties object ID",
                                        "type": "string"
                                    }
                                }
                            }
                        },
                        "resourceCollection": [
                            {
                                "path": "managed/user",
                                "label": "User",
                                "query": {
                                    "queryFilter": "true",
                                    "fields": [
                                        "userName",
                                        "givenName",
                                        "sn"
                                    ]
                                }
                            }
                        ],
                        "userEditable": false
                    },
                    "authzRoles": {
                        "description": "Authorization Roles",
                        "title": "Authorization Roles",
                        "id": "urn:jsonschema:org:forgerock:openidm:managed:api:User:authzRoles",
                        "viewable": true,
                        "type": "array",
                        "userEditable": false,
                        "returnByDefault": false,
                        "usageDescription": null,
                        "isPersonal": false,
                        "items": {
                            "type": "relationship",
                            "title": "Authorization Roles Items",
                            "id": "urn:jsonschema:org:forgerock:openidm:managed:api:User:authzRoles:items",
                            "reverseRelationship": true,
                            "reversePropertyName": "authzMembers",
                            "validate": true,
                            "properties": {
                                "_ref": {
                                    "description": "References a relationship from a managed object",
                                    "type": "string"
                                },
                                "_refProperties": {
                                    "description": "Supports metadata within the relationship",
                                    "type": "object",
                                    "title": "Authorization Roles Items _refProperties",
                                    "properties": {
                                        "_id": {
                                            "description": "_refProperties object ID",
                                            "type": "string"
                                        }
                                    }
                                }
                            },
                            "resourceCollection": [
                                {
                                    "path": "internal/role",
                                    "label": "Internal Role",
                                    "conditionalAssociationField": "condition",
                                    "query": {
                                        "queryFilter": "true",
                                        "fields": [
                                            "name"
                                        ]
                                    }
                                }
                            ]
                        }
                    },
                    "reports": {
                        "description": "Direct Reports",
                        "title": "Direct Reports",
                        "viewable": true,
                        "userEditable": false,
                        "type": "array",
                        "returnByDefault": false,
                        "usageDescription": null,
                        "isPersonal": false,
                        "items": {
                            "type": "relationship",
                            "id": "urn:jsonschema:org:forgerock:openidm:managed:api:User:reports:items",
                            "title": "Direct Reports Items",
                            "reverseRelationship": true,
                            "reversePropertyName": "manager",
                            "validate": true,
                            "properties": {
                                "_ref": {
                                    "description": "References a relationship from a managed object",
                                    "type": "string"
                                },
                                "_refProperties": {
                                    "description": "Supports metadata within the relationship",
                                    "type": "object",
                                    "title": "Direct Reports Items _refProperties",
                                    "properties": {
                                        "_id": {
                                            "description": "_refProperties object ID",
                                            "type": "string"
                                        }
                                    }
                                }
                            },
                            "resourceCollection": [
                                {
                                    "path": "managed/user",
                                    "label": "User",
                                    "query": {
                                        "queryFilter": "true",
                                        "fields": [
                                            "userName",
                                            "givenName",
                                            "sn"
                                        ]
                                    }
                                }
                            ]
                        }
                    },
                    "effectiveRoles": {
                        "type": "array",
                        "title": "Effective Roles",
                        "description": "Effective Roles",
                        "viewable": false,
                        "returnByDefault": true,
                        "isVirtual": true,
                        "usageDescription": null,
                        "isPersonal": false,
                        "queryConfig": {
                            "referencedRelationshipFields": [
                                "roles"
                            ]
                        },
                        "items": {
                            "type": "object",
                            "title": "Effective Roles Items"
                        }
                    },
                    "effectiveAssignments": {
                        "type": "array",
                        "title": "Effective Assignments",
                        "description": "Effective Assignments",
                        "viewable": false,
                        "returnByDefault": true,
                        "isVirtual": true,
                        "usageDescription": null,
                        "isPersonal": false,
                        "queryConfig": {
                            "referencedRelationshipFields": [
                                "roles",
                                "assignments"
                            ],
                            "referencedObjectFields": [
                                "*"
                            ]
                        },
                        "items": {
                            "type": "object",
                            "title": "Effective Assignments Items"
                        }
                    },
                    "lastSync": {
                        "description": "Last Sync timestamp",
                        "title": "Last Sync timestamp",
                        "type": "object",
                        "scope": "private",
                        "viewable": false,
                        "searchable": false,
                        "usageDescription": null,
                        "isPersonal": false,
                        "properties": {
                            "effectiveAssignments": {
                                "description": "Effective Assignments",
                                "title": "Effective Assignments",
                                "type": "array",
                                "items": {
                                    "type": "object",
                                    "title": "Effective Assignments Items"
                                }
                            },
                            "timestamp": {
                                "description": "Timestamp",
                                "type": "string"
                            }
                        },
                        "order": [
                            "effectiveAssignments",
                            "timestamp"
                        ]
                    },
                    "kbaInfo": {
                        "description": "KBA Info",
                        "type": "array",
                        "userEditable": true,
                        "viewable": false,
                        "usageDescription": null,
                        "isPersonal": true,
                        "items": {
                            "type": "object",
                            "title": "KBA Info Items",
                            "properties": {
                                "answer": {
                                    "description": "Answer",
                                    "type": "string"
                                },
                                "customQuestion": {
                                    "description": "Custom question",
                                    "type": "string"
                                },
                                "questionId": {
                                    "description": "Question ID",
                                    "type": "string"
                                }
                            },
                            "order": [
                                "answer",
                                "customQuestion",
                                "questionId"
                            ],
                            "required": []
                        }
                    },
                    "preferences": {
                        "title": "Preferences",
                        "description": "Preferences",
                        "viewable": true,
                        "searchable": false,
                        "userEditable": true,
                        "type": "object",
                        "usageDescription": null,
                        "isPersonal": false,
                        "properties": {
                            "updates": {
                                "description": "Send me news and updates",
                                "type": "boolean"
                            },
                            "marketing": {
                                "description": "Send me special offers and services",
                                "type": "boolean"
                            }
                        },
                        "order": [
                            "updates",
                            "marketing"
                        ]
                    },
                    "consentedMappings": {
                        "title": "Consented Mappings",
                        "description": "Consented Mappings",
                        "type": "array",
                        "viewable": false,
                        "searchable": false,
                        "userEditable": true,
                        "usageDescription": null,
                        "isPersonal": false,
                        "items": {
                            "type": "array",
                            "title": "Consented Mappings Items",
                            "items": {
                                "type": "object",
                                "title": "Consented Mappings Item",
                                "properties": {
                                    "mapping": {
                                        "title": "Mapping",
                                        "description": "Mapping",
                                        "type": "string",
                                        "viewable": true,
                                        "searchable": true,
                                        "userEditable": true
                                    },
                                    "consentDate": {
                                        "title": "Consent Date",
                                        "description": "Consent Date",
                                        "type": "string",
                                        "viewable": true,
                                        "searchable": true,
                                        "userEditable": true
                                    }
                                },
                                "order": [
                                    "mapping",
                                    "consentDate"
                                ],
                                "required": [
                                    "mapping",
                                    "consentDate"
                                ]
                            }
                        },
                        "returnByDefault": false,
                        "isVirtual": false
                    },
                    "ownerOfOrg": {
                        "title": "Organizations I Own",
                        "viewable": true,
                        "searchable": false,
                        "userEditable": false,
                        "policies": [],
                        "returnByDefault": false,
                        "type": "array",
                        "items": {
                            "type": "relationship",
                            "notifySelf": false,
                            "reverseRelationship": true,
                            "reversePropertyName": "owners",
                            "validate": true,
                            "properties": {
                                "_ref": {
                                    "type": "string"
                                },
                                "_refProperties": {
                                    "type": "object",
                                    "properties": {
                                        "_id": {
                                            "type": "string",
                                            "required": false,
                                            "propName": "_id"
                                        }
                                    }
                                }
                            },
                            "resourceCollection": [
                                {
                                    "notify": true,
                                    "path": "managed/organization",
                                    "label": "Organization",
                                    "query": {
                                        "queryFilter": "true",
                                        "fields": [
                                            "name"
                                        ],
                                        "sortKeys": []
                                    }
                                }
                            ]
                        }
                    },
                    "adminOfOrg": {
                        "title": "Organizations I Administer",
                        "viewable": true,
                        "searchable": false,
                        "userEditable": false,
                        "policies": [],
                        "returnByDefault": false,
                        "type": "array",
                        "items": {
                            "type": "relationship",
                            "notifySelf": false,
                            "reverseRelationship": true,
                            "reversePropertyName": "admins",
                            "validate": true,
                            "properties": {
                                "_ref": {
                                    "type": "string"
                                },
                                "_refProperties": {
                                    "type": "object",
                                    "properties": {
                                        "_id": {
                                            "type": "string",
                                            "required": false,
                                            "propName": "_id"
                                        }
                                    }
                                }
                            },
                            "resourceCollection": [
                                {
                                    "notify": true,
                                    "path": "managed/organization",
                                    "label": "Organization",
                                    "query": {
                                        "queryFilter": "true",
                                        "fields": [
                                            "name"
                                        ],
                                        "sortKeys": []
                                    }
                                }
                            ]
                        }
                    },
                    "memberOfOrg": {
                        "title": "Organizations to which I Belong",
                        "viewable": true,
                        "searchable": false,
                        "userEditable": false,
                        "policies": [],
                        "returnByDefault": false,
                        "type": "array",
                        "items": {
                            "type": "relationship",
                            "notifySelf": true,
                            "reverseRelationship": true,
                            "reversePropertyName": "members",
                            "validate": true,
                            "properties": {
                                "_ref": {
                                    "type": "string"
                                },
                                "_refProperties": {
                                    "type": "object",
                                    "properties": {
                                        "_id": {
                                            "type": "string",
                                            "required": false,
                                            "propName": "_id"
                                        }
                                    }
                                }
                            },
                            "resourceCollection": [
                                {
                                    "notify": false,
                                    "path": "managed/organization",
                                    "label": "Organization",
                                    "query": {
                                        "queryFilter": "true",
                                        "fields": [
                                            "name"
                                        ],
                                        "sortKeys": []
                                    }
                                }
                            ]
                        }
                    },
                    "memberOfOrgIDs": {
                        "title": "MemberOfOrgIDs",
                        "type": "array",
                        "viewable": false,
                        "searchable": false,
                        "userEditable": false,
                        "isVirtual": true,
                        "returnByDefault": true,
                        "queryConfig": {
                            "referencedRelationshipFields": [
                                "memberOfOrg"
                            ],
                            "referencedObjectFields": [
                                "_id",
                                "parentIDs"
                            ],
                            "flattenProperties": true
                        },
                        "items": {
                            "type": "string",
                            "title": "org identifiers"
                        }
                    },
                    "activeDate": {
                        "title": "Active Date",
                        "description": "Active Date",
                        "viewable": true,
                        "type": "string",
                        "searchable": false,
                        "userEditable": false,
                        "usageDescription": null,
                        "isPersonal": false
                    },
                    "inactiveDate": {
                        "title": "Inactive Date",
                        "description": "Inactive Date",
                        "viewable": true,
                        "type": "string",
                        "searchable": false,
                        "userEditable": false,
                        "usageDescription": null,
                        "isPersonal": false
                    },
                    "aliasList": {
                        "title": "User Alias Names List",
                        "description": "List of identity aliases used primarily to record social IdP subjects for this user",
                        "type": "array",
                        "items": {
                            "type": "string",
                            "title": "User Alias Names Items"
                        },
                        "viewable": false,
                        "searchable": false,
                        "userEditable": true,
                        "returnByDefault": false,
                        "isVirtual": false
                    },
                    "age": {
                        "title": "How old are you?",
                        "type": "number",
                        "viewable": true,
                        "searchable": true,
                        "userEditable": true
                    }
                },
                "order": [
                    "_id",
                    "userName",
                    "password",
                    "givenName",
                    "cn",
                    "sn",
                    "mail",
                    "profileImage",
                    "description",
                    "accountStatus",
                    "telephoneNumber",
                    "postalAddress",
                    "city",
                    "postalCode",
                    "country",
                    "stateProvince",
                    "assignedDashboard",
                    "roles",
                    "manager",
                    "authzRoles",
                    "reports",
                    "effectiveRoles",
                    "effectiveAssignments",
                    "lastSync",
                    "kbaInfo",
                    "preferences",
                    "consentedMappings",
                    "ownerOfOrg",
                    "adminOfOrg",
                    "memberOfOrg",
                    "memberOfOrgIDs",
                    "activeDate",
                    "inactiveDate",
                    "aliasList",
                    "age"
                ],
                "required": [
                    "userName",
                    "givenName",
                    "sn",
                    "mail"
                ]
            },
            "meta": {
                "property": "_meta",
                "resourceCollection": "internal/usermeta",
                "trackedProperties": [
                    "createDate",
                    "lastChanged"
                ]
            },
            "notifications": {}
        },
        {
            "name": "role",
            "onDelete": {
                "type": "text/javascript",
                "file": "roles/onDelete-roles.js"
            },
            "postCreate": {
                "type": "text/javascript",
                "source": "require('"'"'roles/postOperation-roles'"'"').manageTemporalConstraints(resourceName);"
            },
            "postUpdate": {
                "type": "text/javascript",
                "source": "require('"'"'roles/postOperation-roles'"'"').manageTemporalConstraints(resourceName);"
            },
            "postDelete": {
                "type": "text/javascript",
                "source": "require('"'"'roles/postOperation-roles'"'"').manageTemporalConstraints(resourceName);"
            },
            "schema": {
                "id": "urn:jsonschema:org:forgerock:openidm:managed:api:Role",
                "$schema": "http://forgerock.org/json-schema#",
                "type": "object",
                "title": "Role",
                "icon": "fa-check-square-o",
                "mat-icon": "assignment_ind",
                "description": "",
                "properties": {
                    "_id": {
                        "description": "Role ID",
                        "title": "Name",
                        "viewable": false,
                        "searchable": false,
                        "type": "string"
                    },
                    "name": {
                        "description": "The role name, used for display purposes.",
                        "title": "Name",
                        "viewable": true,
                        "searchable": true,
                        "type": "string"
                    },
                    "description": {
                        "description": "The role description, used for display purposes.",
                        "title": "Description",
                        "viewable": true,
                        "searchable": true,
                        "type": "string"
                    },
                    "members": {
                        "description": "Role Members",
                        "title": "Role Members",
                        "viewable": true,
                        "type": "array",
                        "returnByDefault": false,
                        "relationshipGrantTemporalConstraintsEnforced": true,
                        "items": {
                            "type": "relationship",
                            "id": "urn:jsonschema:org:forgerock:openidm:managed:api:Role:members:items",
                            "title": "Role Members Items",
                            "reverseRelationship": true,
                            "reversePropertyName": "roles",
                            "validate": true,
                            "properties": {
                                "_ref": {
                                    "description": "References a relationship from a managed object",
                                    "type": "string"
                                },
                                "_refProperties": {
                                    "description": "Supports metadata within the relationship",
                                    "type": "object",
                                    "title": "Role Members Items _refProperties",
                                    "properties": {
                                        "_id": {
                                            "description": "_refProperties object ID",
                                            "type": "string"
                                        },
                                        "_grantType": {
                                            "description": "Grant Type",
                                            "type": "string",
                                            "label": "Grant Type"
                                        }
                                    }
                                }
                            },
                            "resourceCollection": [
                                {
                                    "notify": true,
                                    "conditionalAssociation": true,
                                    "path": "managed/user",
                                    "label": "User",
                                    "query": {
                                        "queryFilter": "true",
                                        "fields": [
                                            "userName",
                                            "givenName",
                                            "sn"
                                        ]
                                    }
                                }
                            ]
                        }
                    },
                    "assignments": {
                        "description": "Managed Assignments",
                        "title": "Managed Assignments",
                        "viewable": true,
                        "returnByDefault": false,
                        "type": "array",
                        "items": {
                            "type": "relationship",
                            "id": "urn:jsonschema:org:forgerock:openidm:managed:api:Role:assignments:items",
                            "title": "Managed Assignments Items",
                            "reverseRelationship": true,
                            "reversePropertyName": "roles",
                            "notifySelf": true,
                            "validate": true,
                            "properties": {
                                "_ref": {
                                    "description": "References a relationship from a managed object",
                                    "type": "string"
                                },
                                "_refProperties": {
                                    "description": "Supports metadata within the relationship",
                                    "title": "Managed Assignments Items _refProperties",
                                    "type": "object",
                                    "properties": {
                                        "_id": {
                                            "description": "_refProperties object ID",
                                            "type": "string"
                                        }
                                    }
                                }
                            },
                            "resourceCollection": [
                                {
                                    "path": "managed/assignment",
                                    "label": "Assignment",
                                    "query": {
                                        "queryFilter": "true",
                                        "fields": [
                                            "name"
                                        ]
                                    }
                                }
                            ]
                        },
                        "notifyRelationships": [
                            "members"
                        ]
                    },
                    "condition": {
                        "description": "A conditional filter for this role",
                        "title": "Condition",
                        "viewable": false,
                        "searchable": false,
                        "isConditional": true,
                        "type": "string"
                    },
                    "temporalConstraints": {
                        "description": "An array of temporal constraints for a role",
                        "title": "Temporal Constraints",
                        "viewable": false,
                        "returnByDefault": true,
                        "isTemporalConstraint": true,
                        "type": "array",
                        "items": {
                            "type": "object",
                            "title": "Temporal Constraints Items",
                            "properties": {
                                "duration": {
                                    "description": "Duration",
                                    "type": "string"
                                }
                            },
                            "required": [
                                "duration"
                            ],
                            "order": [
                                "duration"
                            ]
                        },
                        "notifyRelationships": [
                            "members"
                        ]
                    }
                },
                "required": [
                    "name"
                ],
                "order": [
                    "_id",
                    "name",
                    "description",
                    "members",
                    "assignments",
                    "condition",
                    "temporalConstraints"
                ]
            }
        },
        {
            "name": "assignment",
            "schema": {
                "id": "urn:jsonschema:org:forgerock:openidm:managed:api:Assignment",
                "$schema": "http://forgerock.org/json-schema#",
                "type": "object",
                "title": "Assignment",
                "icon": "fa-key",
                "mat-icon": "vpn_key",
                "description": "A role assignment",
                "properties": {
                    "_id": {
                        "description": "The assignment ID",
                        "title": "Name",
                        "viewable": false,
                        "searchable": false,
                        "type": "string"
                    },
                    "name": {
                        "description": "The assignment name, used for display purposes.",
                        "title": "Name",
                        "viewable": true,
                        "searchable": true,
                        "type": "string"
                    },
                    "description": {
                        "description": "The assignment description, used for display purposes.",
                        "title": "Description",
                        "viewable": true,
                        "searchable": true,
                        "type": "string"
                    },
                    "mapping": {
                        "description": "The name of the mapping this assignment applies to",
                        "title": "Mapping",
                        "viewable": true,
                        "searchable": true,
                        "type": "string",
                        "policies": [
                            {
                                "policyId": "mapping-exists"
                            }
                        ]
                    },
                    "attributes": {
                        "description": "The attributes operated on by this assignment.",
                        "title": "Assignment Attributes",
                        "viewable": true,
                        "type": "array",
                        "items": {
                            "type": "object",
                            "title": "Assignment Attributes Items",
                            "properties": {
                                "assignmentOperation": {
                                    "description": "Assignment operation",
                                    "type": "string"
                                },
                                "unassignmentOperation": {
                                    "description": "Unassignment operation",
                                    "type": "string"
                                },
                                "name": {
                                    "description": "Name",
                                    "type": "string"
                                },
                                "value": {
                                    "description": "Value",
                                    "type": "string"
                                }
                            },
                            "order": [
                                "assignmentOperation",
                                "unassignmentOperation",
                                "name",
                                "value"
                            ],
                            "required": []
                        },
                        "notifyRelationships": [
                            "roles"
                        ]
                    },
                    "linkQualifiers": {
                        "description": "Conditional link qualifiers to restrict this assignment to.",
                        "title": "Link Qualifiers",
                        "viewable": true,
                        "type": "array",
                        "items": {
                            "type": "string",
                            "title": "Link Qualifiers Items"
                        }
                    },
                    "roles": {
                        "description": "Managed Roles",
                        "title": "Managed Roles",
                        "viewable": true,
                        "userEditable": false,
                        "type": "array",
                        "returnByDefault": false,
                        "items": {
                            "type": "relationship",
                            "id": "urn:jsonschema:org:forgerock:openidm:managed:api:Assignment:roles:items",
                            "title": "Managed Roles Items",
                            "reverseRelationship": true,
                            "reversePropertyName": "assignments",
                            "validate": true,
                            "properties": {
                                "_ref": {
                                    "description": "References a relationship from a managed object",
                                    "type": "string"
                                },
                                "_refProperties": {
                                    "description": "Supports metadata within the relationship",
                                    "type": "object",
                                    "title": "Managed Roles Items _refProperties",
                                    "properties": {
                                        "_id": {
                                            "description": "_refProperties object ID",
                                            "type": "string"
                                        }
                                    }
                                }
                            },
                            "resourceCollection": [
                                {
                                    "notify": true,
                                    "path": "managed/role",
                                    "label": "Role",
                                    "query": {
                                        "queryFilter": "true",
                                        "fields": [
                                            "name"
                                        ]
                                    }
                                }
                            ]
                        }
                    }
                },
                "required": [
                    "name",
                    "description",
                    "mapping"
                ],
                "order": [
                    "_id",
                    "name",
                    "description",
                    "mapping",
                    "attributes",
                    "linkQualifiers",
                    "roles"
                ]
            }
        },
        {
            "name": "organization",
            "schema": {
                "$schema": "http://forgerock.org/json-schema#",
                "type": "object",
                "title": "Organization",
                "description": "An organization or tenant, whose resources are managed by organizational admins.",
                "icon": "fa-building",
                "mat-icon": "domain",
                "properties": {
                    "name": {
                        "title": "Name",
                        "type": "string",
                        "viewable": true,
                        "searchable": true,
                        "userEditable": true
                    },
                    "description": {
                        "title": "Description",
                        "type": "string",
                        "viewable": true,
                        "searchable": true,
                        "userEditable": true
                    },
                    "owners": {
                        "title": "Owner",
                        "viewable": true,
                        "searchable": false,
                        "userEditable": false,
                        "returnByDefault": false,
                        "type": "array",
                        "items": {
                            "type": "relationship",
                            "notifySelf": true,
                            "reverseRelationship": true,
                            "reversePropertyName": "ownerOfOrg",
                            "validate": true,
                            "properties": {
                                "_ref": {
                                    "type": "string"
                                },
                                "_refProperties": {
                                    "type": "object",
                                    "properties": {
                                        "_id": {
                                            "type": "string",
                                            "required": false,
                                            "propName": "_id"
                                        }
                                    }
                                }
                            },
                            "resourceCollection": [
                                {
                                    "notify": false,
                                    "path": "managed/user",
                                    "label": "User",
                                    "query": {
                                        "queryFilter": "true",
                                        "fields": [
                                            "userName",
                                            "givenName",
                                            "sn"
                                        ],
                                        "sortKeys": []
                                    }
                                }
                            ]
                        },
                        "notifyRelationships": [
                            "children"
                        ]
                    },
                    "admins": {
                        "title": "Administrators",
                        "viewable": true,
                        "searchable": false,
                        "userEditable": false,
                        "returnByDefault": false,
                        "type": "array",
                        "items": {
                            "type": "relationship",
                            "notifySelf": true,
                            "reverseRelationship": true,
                            "reversePropertyName": "adminOfOrg",
                            "validate": true,
                            "properties": {
                                "_ref": {
                                    "type": "string"
                                },
                                "_refProperties": {
                                    "type": "object",
                                    "properties": {
                                        "_id": {
                                            "type": "string",
                                            "required": false,
                                            "propName": "_id"
                                        }
                                    }
                                }
                            },
                            "resourceCollection": [
                                {
                                    "notify": false,
                                    "path": "managed/user",
                                    "label": "User",
                                    "query": {
                                        "queryFilter": "true",
                                        "fields": [
                                            "userName",
                                            "givenName",
                                            "sn"
                                        ],
                                        "sortKeys": []
                                    }
                                }
                            ]
                        },
                        "notifyRelationships": [
                            "children"
                        ]
                    },
                    "members": {
                        "title": "Members",
                        "viewable": true,
                        "searchable": false,
                        "userEditable": false,
                        "returnByDefault": false,
                        "type": "array",
                        "items": {
                            "type": "relationship",
                            "notifySelf": false,
                            "reverseRelationship": true,
                            "reversePropertyName": "memberOfOrg",
                            "validate": true,
                            "properties": {
                                "_ref": {
                                    "type": "string"
                                },
                                "_refProperties": {
                                    "type": "object",
                                    "properties": {
                                        "_id": {
                                            "type": "string",
                                            "required": false,
                                            "propName": "_id"
                                        }
                                    }
                                }
                            },
                            "resourceCollection": [
                                {
                                    "notify": true,
                                    "path": "managed/user",
                                    "label": "User",
                                    "query": {
                                        "queryFilter": "true",
                                        "fields": [
                                            "userName",
                                            "givenName",
                                            "sn"
                                        ],
                                        "sortKeys": []
                                    }
                                }
                            ]
                        }
                    },
                    "parent": {
                        "title": "Parent Organization",
                        "description": "Parent Organization",
                        "type": "relationship",
                        "notifySelf": true,
                        "viewable": true,
                        "searchable": false,
                        "userEditable": false,
                        "returnByDefault": false,
                        "reverseRelationship": true,
                        "reversePropertyName": "children",
                        "validate": true,
                        "properties": {
                            "_ref": {
                                "type": "string"
                            },
                            "_refProperties": {
                                "type": "object",
                                "properties": {
                                    "_id": {
                                        "type": "string",
                                        "required": false,
                                        "propName": "_id"
                                    }
                                }
                            }
                        },
                        "resourceCollection": [
                            {
                                "path": "managed/organization",
                                "notify": true,
                                "label": "Organization",
                                "query": {
                                    "queryFilter": "true",
                                    "fields": [
                                        "name",
                                        "description"
                                    ],
                                    "sortKeys": []
                                }
                            }
                        ],
                        "notifyRelationships": [
                            "children",
                            "members"
                        ]
                    },
                    "children": {
                        "description": "Child Organizations",
                        "title": "Child Organizations",
                        "viewable": false,
                        "searchable": false,
                        "userEditable": false,
                        "policies": [],
                        "returnByDefault": false,
                        "type": "array",
                        "items": {
                            "type": "relationship",
                            "reverseRelationship": true,
                            "reversePropertyName": "parent",
                            "validate": true,
                            "notifySelf": true,
                            "properties": {
                                "_ref": {
                                    "type": "string"
                                },
                                "_refProperties": {
                                    "type": "object",
                                    "properties": {
                                        "_id": {
                                            "type": "string",
                                            "required": false,
                                            "propName": "_id"
                                        }
                                    }
                                }
                            },
                            "resourceCollection": [
                                {
                                    "path": "managed/organization",
                                    "notify": true,
                                    "label": "Organization",
                                    "query": {
                                        "queryFilter": "true",
                                        "fields": [
                                            "name",
                                            "description"
                                        ],
                                        "sortKeys": []
                                    }
                                }
                            ]
                        }
                    },
                    "adminIDs": {
                        "title": "Admin user ids",
                        "type": "array",
                        "viewable": false,
                        "searchable": false,
                        "userEditable": false,
                        "isVirtual": true,
                        "returnByDefault": true,
                        "queryConfig": {
                            "referencedRelationshipFields": [
                                "admins"
                            ],
                            "referencedObjectFields": [
                                "_id"
                            ],
                            "flattenProperties": true
                        },
                        "items": {
                            "type": "string",
                            "title": "admin ids"
                        }
                    },
                    "ownerIDs": {
                        "title": "Owner user ids",
                        "type": "array",
                        "viewable": false,
                        "searchable": false,
                        "userEditable": false,
                        "isVirtual": true,
                        "returnByDefault": true,
                        "queryConfig": {
                            "referencedRelationshipFields": [
                                "owners"
                            ],
                            "referencedObjectFields": [
                                "_id"
                            ],
                            "flattenProperties": true
                        },
                        "items": {
                            "type": "string",
                            "title": "owner ids"
                        }
                    },
                    "parentAdminIDs": {
                        "title": "user ids of parent admins",
                        "type": "array",
                        "viewable": false,
                        "searchable": false,
                        "userEditable": false,
                        "isVirtual": true,
                        "returnByDefault": true,
                        "queryConfig": {
                            "referencedRelationshipFields": [
                                "parent"
                            ],
                            "referencedObjectFields": [
                                "adminIDs",
                                "parentAdminIDs"
                            ],
                            "flattenProperties": true
                        },
                        "items": {
                            "type": "string",
                            "title": "user ids of parent admins"
                        }
                    },
                    "parentOwnerIDs": {
                        "title": "user ids of parent owners",
                        "type": "array",
                        "viewable": false,
                        "searchable": false,
                        "userEditable": false,
                        "isVirtual": true,
                        "returnByDefault": true,
                        "queryConfig": {
                            "referencedRelationshipFields": [
                                "parent"
                            ],
                            "referencedObjectFields": [
                                "ownerIDs",
                                "parentOwnerIDs"
                            ],
                            "flattenProperties": true
                        },
                        "items": {
                            "type": "string",
                            "title": "user ids of parent owners"
                        }
                    },
                    "parentIDs": {
                        "title": "parent org ids",
                        "type": "array",
                        "viewable": false,
                        "searchable": false,
                        "userEditable": false,
                        "isVirtual": true,
                        "returnByDefault": true,
                        "queryConfig": {
                            "referencedRelationshipFields": [
                                "parent"
                            ],
                            "referencedObjectFields": [
                                "_id",
                                "parentIDs"
                            ],
                            "flattenProperties": true
                        },
                        "items": {
                            "type": "string",
                            "title": "parent org ids"
                        }
                    }
                },
                "order": [
                    "name",
                    "description",
                    "owners",
                    "admins",
                    "members",
                    "parent",
                    "children",
                    "adminIDs",
                    "ownerIDs",
                    "parentAdminIDs",
                    "parentOwnerIDs",
                    "parentIDs"
                ],
                "required": [
                    "name"
                ]
            }
        }
    ]
}' \
"$IDM_URL/config/managed" --insecure