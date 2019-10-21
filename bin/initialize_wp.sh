#!/bin/bash

self=$(cd $(dirname $0); pwd)

[ ! -f ${self}/.env ] && {
    echo 'There is no .env file.'
    exit 1
}

. ${self}/.env
cd ${self}

db_container=$(docker-compose up -d toybox-wp-cli-mariadb)

function _install_wp() {
    docker-compose run --rm \
        toybox-wp-cli \
        wp core download \
        --version=${WP_VERSION} \
        --locale=${WP_LOCALE} \
        --path=/usr/share/nginx/html \
        --allow-root
}
function _setup_wp_config() {
    docker-compose run --rm \
        toybox-wp-cli \
        wp config create \
        --dbname=${DB_NAME} \
        --dbuser=${DB_USER} \
        --dbpass=${DB_PASSWORD} \
        --dbhost=${DB_HOST} \
        --dbprefix=${DB_TABLE_PREFIX} \
        --path=/usr/share/nginx/html \
        --allow-root
}
function _setup_wp_admin() {
    docker-compose run --rm \
        toybox-wp-cli \
        wp core install \
        --url=http://test.com/ \
        --title="TEST BLOG" \
        --admin_user=hancock_jp \
        --admin_password=bunnta04210310 \
        --admin_email=dev@nutsllc.com \
        --path=/usr/share/nginx/html \
        --allow-root
}
function _setup_wp_system() {
    docker-compose run --rm \
        toybox-wp-cli \
        wp option update timezone_string 'Asia/Tokyo'
}
function _wp_initial_setup() {
    docker-compose run --rm \
        toybox-wp-cli \
        wp post delete 1 2 3 --force \
        && wp plugin uninstall 'Hello Dolly'
}

function _setup_wordpress() {
    _install_wp && {
        _setup_wp_config
    } && {
        _setup_wp_admin
    }
}
_setup_wordpress
docker down ${db_container} && {
    echo 'complete!'
} || echo 'error!'


exit 0
