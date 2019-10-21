#!/bin/bash

self=$(cd $(dirname $0); pwd)

[ ! -f ${self}/.env ] && {
    echo 'There is no .env file.'
    exit 1
}

. ${self}/.env
cd ${self}

function _show_version() {
    docker-compose run --rm \
        toybox-wp-cli \
        wp cli version \
        --allow-root
}
_show_version

exit 0
