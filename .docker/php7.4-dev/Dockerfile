ARG DOCKER_SERVER_HOST
ARG DOCKER_SERVER_PORT
ARG DOCKER_PROJECT_PATH
ARG DOCKER_PHP_VERSION
ARG DOCKER_IMAGE_VERSION=master
ARG DOCKER_UID=1000
ARG DOCKER_GID=1000

FROM ${DOCKER_SERVER_HOST}:${DOCKER_SERVER_PORT}/${DOCKER_PROJECT_PATH}/php${DOCKER_PHP_VERSION}-composer:${DOCKER_IMAGE_VERSION}

WORKDIR /app

# -------------------- Installing PHP Extension: xdebug --------------------
RUN set -eux \
	# Installation: Generic
	# Type:         PECL extension
	# Default:      Pecl command
	&& pecl install xdebug \
	# Enabling
	&& docker-php-ext-enable xdebug \
	&& true

# -------------------- Delete extracted php source --------------------
RUN set -eux \
    && docker-php-source delete \
    && true

USER app

RUN composer -vvv global require ergebnis/composer-normalize
RUN composer -vvv global require pyrech/composer-changelogs

USER root

COPY php.dev.ini $PHP_INI_DIR/php.ini
