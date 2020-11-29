#!/usr/bin/env bash
function build_base_image() {
    echo $1
    IMAGE=$2
    DOCKER_PATH=$3
    docker_build_dir_args \
        ${IMAGE} \
        ${DOCKER_PATH} \
        "\
            --build-arg DOCKER_SERVER_HOST=$DOCKER_SERVER_HOST \
            --build-arg DOCKER_SERVER_PORT=$DOCKER_SERVER_PORT \
            --build-arg DOCKER_PROJECT_PATH=$DOCKER_PROJECT_PATH \
            --build-arg DOCKER_PHP_VERSION=$DOCKER_PHP_VERSION \
            --build-arg DOCKER_IMAGE_VERSION=$DOCKER_IMAGE_VERSION \
        "
    docker push ${IMAGE}
}


build_base_image "BUILD php-fpm" \
    "$DOCKER_SERVER_HOST:$DOCKER_SERVER_PORT/$DOCKER_PROJECT_PATH/php${DOCKER_PHP_VERSION}-fpm:$DOCKER_IMAGE_VERSION" \
    ".docker/php${DOCKER_PHP_VERSION}-fpm/"

build_base_image "BUILD composer" \
    "$DOCKER_SERVER_HOST:$DOCKER_SERVER_PORT/$DOCKER_PROJECT_PATH/php${DOCKER_PHP_VERSION}-composer:$DOCKER_IMAGE_VERSION" \
    ".docker/php${DOCKER_PHP_VERSION}-composer/"
