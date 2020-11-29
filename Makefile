include .env
export

RUN_ARGS = $(filter-out $@,$(MAKECMDGOALS))

include .pipelines/.pipelines-debug.mk
include .make/composer.mk
include .make/docker-compose-shared-services.mk
include .make/static-analysis.mk
include .make/utils.mk

.PHONY: help
help: ## Display this help message
	@cat $(MAKEFILE_LIST) | grep -e "^[a-zA-Z_\-]*: *.*## *" | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: ps
ps: ## list of container
	docker-compose ps

.PHONY: up
up: ## spin up environment
	docker-compose up -d

.PHONY: stop
stop: ## stop environment
	docker-compose stop

.PHONY: erase
erase: ## stop and delete containers, clean volumes.
	docker-compose stop
	docker-compose rm -v -f

.PHONY: build
build: ## build environment and initialize composer and project dependencies
	docker build .docker/php$(DOCKER_PHP_VERSION)-fpm/ -t $(DOCKER_SERVER_HOST):$(DOCKER_SERVER_PORT)/$(DOCKER_PROJECT_PATH)/php$(DOCKER_PHP_VERSION)-fpm:$(DOCKER_IMAGE_VERSION) \
	--build-arg DOCKER_SERVER_HOST=$(DOCKER_SERVER_HOST) \
	--build-arg DOCKER_SERVER_PORT=$(DOCKER_SERVER_PORT) \
	--build-arg DOCKER_PROJECT_PATH=$(DOCKER_PROJECT_PATH) \
	--build-arg DOCKER_PHP_VERSION=$(DOCKER_PHP_VERSION) \
	--build-arg DOCKER_IMAGE_VERSION=$(DOCKER_IMAGE_VERSION)
	docker build .docker/php$(DOCKER_PHP_VERSION)-composer/ -t $(DOCKER_SERVER_HOST):$(DOCKER_SERVER_PORT)/$(DOCKER_PROJECT_PATH)/php$(DOCKER_PHP_VERSION)-composer:$(DOCKER_IMAGE_VERSION) \
	--build-arg DOCKER_SERVER_HOST=$(DOCKER_SERVER_HOST) \
	--build-arg DOCKER_SERVER_PORT=$(DOCKER_SERVER_PORT) \
	--build-arg DOCKER_PROJECT_PATH=$(DOCKER_PROJECT_PATH) \
	--build-arg DOCKER_PHP_VERSION=$(DOCKER_PHP_VERSION) \
	--build-arg DOCKER_IMAGE_VERSION=$(DOCKER_IMAGE_VERSION)
	docker build .docker/php$(DOCKER_PHP_VERSION)-dev/ -t $(DOCKER_SERVER_HOST):$(DOCKER_SERVER_PORT)/$(DOCKER_PROJECT_PATH)/php$(DOCKER_PHP_VERSION)-dev:$(DOCKER_IMAGE_VERSION) \
	--build-arg DOCKER_SERVER_HOST=$(DOCKER_SERVER_HOST) \
	--build-arg DOCKER_SERVER_PORT=$(DOCKER_SERVER_PORT) \
	--build-arg DOCKER_PROJECT_PATH=$(DOCKER_PROJECT_PATH) \
	--build-arg DOCKER_PHP_VERSION=$(DOCKER_PHP_VERSION) \
	--build-arg DOCKER_IMAGE_VERSION=$(DOCKER_IMAGE_VERSION)
	docker-compose build
	make composer-install

setup:
	make setup-db

.PHONY: setup-db
setup-db: ## run database migration
	make db-migration-migrate


.PHONY: migration-migrate
db-migration-migrate: ## generate new database migration
	docker-compose run --rm php sh -lc './bin/console d:m:m -n --force'
