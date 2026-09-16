#!/bin/bash

java \
    -Djdk.tls.maxHandshakeMessageSize=65536 \
    -Dspring.mongodb.uri="mongodb://${MONGODB_HOST}:27017/test_suite" \
    -jar /server/fapi-test-suite.jar \
    --fintechlabs.base_url=$BASE_URL \
    --fintechlabs.directoryroots.uri=$DIRECTORYROOTS_URL \
    --fintechlabs.yacs.directory.uri=$DIRECTORY_PARTICIPANTS_URL \
    --fintechlabs.devmode=true \
    --fintechlabs.startredir=true
