ARG DOCKER_SERVER_HOST
ARG DOCKER_SERVER_PORT
ARG DOCKER_PROJECT_PATH
ARG DOCKER_PHP_VERSION
ARG DOCKER_IMAGE_VERSION=master

FROM ${DOCKER_SERVER_HOST}:${DOCKER_SERVER_PORT}/${DOCKER_PROJECT_PATH}/php${DOCKER_PHP_VERSION}-composer:${DOCKER_IMAGE_VERSION} AS composer

# These ARGs should be after FROM or they will be empty
ARG COMPOSER_INSTALL_CMD

WORKDIR /app
COPY composer.json /app/composer.json
COPY composer.lock /app/composer.lock
COPY symfony.lock /app/symfony.lock

RUN bash -c "${COMPOSER_INSTALL_CMD}"

COPY . /app