#!/bin/bash

for DIR in $(find . -mindepth 1 -maxdepth 1 -type d -not -path '*/\.*'); do
    cd ${DIR}
    if [ -f docker-compose.yml ]; then
        docker-compose down --remove-orphans
    fi
    cd -
done
