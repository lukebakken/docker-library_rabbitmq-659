.PHONY: check clean up down

DOCKER_FRESH ?= false

BUILD_ENV ?= DEV
RABBITMQ_USER ?= admin
RABBITMQ_PASS ?= foobar
RABBITMQ_PORT ?= 5672
RABBITMQ_ADMIN_PORT ?= 15672
RABBITMQ_STORAGE ?= $(CURDIR)/data

export RABBITMQ_USER
export RABBITMQ_PASS
export RABBITMQ_PORT
export RABBITMQ_ADMIN_PORT
export RABBITMQ_STORAGE

up: clean
ifeq ($(BUILD_ENV),DEV)
	@echo [INFO] BUILD_ENV: $(BUILD_ENV)
else ifeq ($(BUILD_ENV),PROD)
	@echo [INFO] BUILD_ENV: $(BUILD_ENV)
else
	$(error Please set BUILD_ENV to DEV or PROD)
endif
ifeq ($(DOCKER_FRESH),true)
	docker compose build --no-cache --pull --build-arg BUILD_ENV=$(BUILD_ENV)
	docker compose up --pull always
else
	docker compose build --build-arg BUILD_ENV=$(BUILD_ENV)
	docker compose up
endif

down:
	docker compose down

clean:
	sudo chown -R $(USER) $(CURDIR)/data
	git clean -xffd

check:
	set -eux; \
		container_id="$$(docker compose ps -q rabbitmq)" && \
		docker exec "$$container_id" rabbitmqctl authenticate_user $(RABBITMQ_USER)-$(BUILD_ENV) $(RABBITMQ_PASS)
