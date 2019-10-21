FROM php:7.4-rc-cli-alpine3.10
MAINTAINER NutsProject, LLC <dev@nutsllc.jp>

ENV UID=1000 \
    GID=1000 \
    USER_NAME=toybox \
    GROUP_NAME=toybox

RUN addgroup -g ${GID} ${GROUP_NAME}\
    && adduser -u ${UID} -D -G ${GROUP_NAME} ${USER_NAME}

RUN apk add --update --no-cache \
        curl \
        mysql-client \
    && docker-php-ext-install mysqli \
    && curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp
