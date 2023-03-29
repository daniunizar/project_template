## Variables
LOCAL_USER := $(shell whoami)
DOMAIN_NAME := 'php-laravel.local.novadevs.com'
HTTP_PORT := '8080'
HTTPS_PORT := '8081'
NGINX_CONTAINER := 'php-laravel-template_nginx'
WEB_CONTAINER := 'php-laravel-template_php-fpm'
WEB_IMG_LABEL := 'php-laravel-template'
DB_CONTAINER := 'php-laravel-template_db'
DB_CONTAINER_TESTING := 'php-laravel-template_db-testing'
APP_IMG := $(shell docker images -q --filter label=custom.project=$(WEB_IMG_LABEL) --format "{{.ID}}")
PROJ_ENV = local
PROJ_SCRIPT = app_configuration
DOCKER_COMPOSE = docker-compose -f ./docker/${PROJ_ENV}/docker-compose.yml

## Global configuration
.DELETE_ON_ERROR:

help:
	@echo 'Makefile for generating documents from Asciidoc source files            '
	@echo '                                                                        '
	@echo 'Usage:                                                                  '
	@echo '   make                         Print the help                          '
	@echo '   make build                   Build the environment from scratch      '
	@echo '   make up                      Start the environment                   '
	@echo '   make stop                    Stop the environment                    '
	@echo '   make status                  Display the containers status           '
	@echo '   make clean                   Clean the environment                   '
	@echo '   make cache                   Clean application cache                 '
	@echo '   make perm                    Set the permissions of the application  '
	@echo '   make update                  Update the application                  '
	@echo '   make nginx                   Connect to the nginx    container       '
	@echo '   make sh                      Connect to the php container            '
	@echo '   make db                      Connect to the database container       '
	@echo '   make db-refresh              Reset the database to default           '
	@echo '   make db-run-migrations       Run database migrations                 '
	@echo '   make tests                   Run the tests                           '
	@echo '   make clean-tests             Clean the environment and run the tests '
	@echo '   make urls                    Print the applications URLs             '
	@echo '   make help                    Print the help                          '

urls:
	@echo "\nYou should add the following entry in the configuration file /etc/hosts"
	@echo '   127.0.0.1 $(DOMAIN_NAME)'
	@echo ''
	@echo 'The available URLs are:'
	@echo '   http://$(DOMAIN_NAME):$(HTTP_PORT)'
	@echo '   https://$(DOMAIN_NAME):$(HTTPS_PORT)'
	@echo '   http://localhost:$(HTTP_PORT)'
	@echo '   https://localhost:$(HTTPS_PORT)'

build:
ifeq (,$(wildcard .env))
	@echo 'The configuration file ".env" does not exist. Please, create it following the README instructions.'
	@exit 1
endif

ifeq (,$(wildcard .env.testing))
	@echo 'The configuration file ".env.testing" does not exist. Please, create it following the README instructions.'
	@exit 1
endif

	$(MAKE) clean

	@echo 'Setting up the environment...'
	@${DOCKER_COMPOSE} build --no-cache

	@${DOCKER_COMPOSE} up -d
	@sleep 30

	@echo 'Configuring the application...'
	@docker exec -t $(WEB_CONTAINER) /bin/bash docker/${PROJ_ENV}/${PROJ_SCRIPT} fresh

	$(MAKE) tests

	$(MAKE) urls

up:
	@echo "\nStarting the environment..."

	@${DOCKER_COMPOSE} start

	$(MAKE) urls

stop:
	@echo 'Stopping the environment...'

	@${DOCKER_COMPOSE} stop

status:
	@echo 'Displaying the status of the container...'

	@${DOCKER_COMPOSE} ps

cache:
	@echo 'Cleaning the cache...'

	@docker exec -t $(WEB_CONTAINER) /bin/bash docker/${PROJ_ENV}/${PROJ_SCRIPT} cache

db-refresh:
	@echo 'Running php artisan migrate:fresh --seed ...'

	@docker exec -t $(WEB_CONTAINER) /usr/local/bin/php artisan migrate:fresh --seed --force

db-run-migrations:
	@echo 'Running migrations'

	@docker exec -t $(WEB_CONTAINER) /usr/local/bin/php artisan migrate  --force

perm:
	@echo 'Setting the permissions to project...'

	@docker exec -t $(WEB_CONTAINER) /bin/bash docker/${PROJ_ENV}/${PROJ_SCRIPT} permissions

update:
	@echo 'Updating the project'

	@docker exec -t $(WEB_CONTAINER) /bin/bash docker/${PROJ_ENV}/${PROJ_SCRIPT} update

nginx:
	@echo 'Connecting to Nginx container...'

	@docker exec -ti $(NGINX_CONTAINER) /bin/bash

sh:
	@echo 'Connecting to Web container...'

	@docker exec -ti $(WEB_CONTAINER) /bin/bash

db:
	@echo 'Connecting to Database container...'

	@docker exec -ti $(DB_CONTAINER) /bin/bash

clean:
	@echo 'Cleaning the environment...'

	@${DOCKER_COMPOSE} down -v -t 20
	@echo $(APP_IMG)

ifneq ($(strip $(APP_IMG)),)
	@docker rmi $(APP_IMG)
endif

	@echo "\nThe environment was cleaned, but remember that the 'vendor' directory may still exist."

.PHONY: all tests clean
tests:
	@echo 'Running tests...'

	@docker exec -t $(WEB_CONTAINER) /usr/local/bin/php artisan test

clean-tests:
	@echo 'Cleaning the environment...'
	$(MAKE) clean

	@echo 'Building the environment to just run the tests...'

	@${DOCKER_COMPOSE} build --no-cache
	@${DOCKER_COMPOSE} up -d
	@sleep 30

	@docker exec -t $(WEB_CONTAINER) /bin/bash docker/${PROJ_ENV}/${PROJ_SCRIPT} tests

	$(MAKE) tests
