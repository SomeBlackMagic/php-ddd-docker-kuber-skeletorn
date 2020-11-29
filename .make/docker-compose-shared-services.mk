ifeq ($(OS),Windows_NT)
	CWD := $(lastword $(dir $(realpath $(MAKEFILE_LIST)/../)))
else
	CWD := $(abspath $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST))))/../))/
endif

shared-service-up: ## Setup shared service, mysql,redis,rabbit,etc...
	docker-compose --project-directory $(CWD)/ -f $(CWD)/docker-compose-shared-services.yml up -d --force-recreate

shared-service-erase:
	docker-compose --project-directory $(CWD)/ -f $(CWD)/docker-compose-shared-services.yml stop
	docker-compose --project-directory $(CWD)/ -f $(CWD)/docker-compose-shared-services.yml down --volumes --remove-orphans

shared-service-stop:
	docker-compose --project-directory $(CWD)/ -f $(CWD)/docker-compose-shared-services.yml stop

shared-service-logs:
	docker-compose --project-directory $(CWD)/ -f $(CWD)/docker-compose-shared-services.yml logs -f

shared-service-ps:
	docker-compose --project-directory $(CWD)/ -f $(CWD)/docker-compose-shared-services.yml ps
