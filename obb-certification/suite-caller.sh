#!/bin/bash

java \
    -jar /server/fapi-test-suite.jar \
    --fintechlabs.base_url=$BASE_URL \
    --fintechlabs.directoryroots.uri=$DIRECTORYROOTS_URL \
    --fintechlabs.yacs.directory.uri=$DIRECTORY_PARTICIPANTS_URL \
    --fintechlabs.devmode=true \
    --fintechlabs.startredir=true \
    -Djdk.tls.maxHandshakeMessageSize=65536