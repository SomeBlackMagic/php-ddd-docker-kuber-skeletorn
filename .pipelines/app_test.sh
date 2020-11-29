#!/usr/bin/env bash
################### run tests ###################
function dev_app_test() {
    IMAGE=${DOCKER_SERVER_HOST}:${DOCKER_SERVER_PORT}/${DOCKER_PROJECT_PATH}/app_test:${DOCKER_IMAGE_VERSION}
    COMMAND=$1
    docker run --rm -t $IMAGE $COMMAND
}

dev_app_test "php bin/console lint:yaml config --parse-tags"
dev_app_test "vendor/bin/parallel-lint ./ --exclude vendor"
#dev_app_test "vendor/bin/phpstan analyse -l 6 -c phpstan.neon src tests" todo remove
dev_app_test "vendor/bin/psalm --config=psalm.xml --show-info=false"
dev_app_test "composer validate --no-check-publish"
dev_app_test "vendor/bin/ecs check src tests --fix"
#dev_app_test "vendor/bin/deptrac analyze --formatter-graphviz=0"
