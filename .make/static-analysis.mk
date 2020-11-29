static-analysis: lint style coding-standards ## Run phpstan, deprac, easycoding standarts code static analysis

style: ## executes php analizers
	docker-compose run --rm --no-deps php sh -lc './vendor/bin/phpstan analyse -l 6 -c phpstan.neon src tests'
	docker-compose run --rm --no-deps php sh -lc './vendor/bin/psalm --config=psalm.xml --show-info=false'

lint: ## checks syntax of PHP files
	docker-compose run --rm --no-deps php sh -lc './vendor/bin/parallel-lint ./ --exclude vendor'
	docker-compose run --rm --no-deps php sh -lc './bin/console lint:yaml config'

coding-standards: ## Run check and validate code standards tests
	docker-compose run --rm --no-deps php sh -lc 'vendor/bin/ecs check src tests'
	docker-compose run --rm --no-deps php sh -lc 'vendor/bin/phpmd src/ text phpmd.xml'

coding-standards-fixer: ## Run code standards fixer
	docker-compose run --rm --no-deps php sh -lc 'vendor/bin/ecs check src tests --fix'
