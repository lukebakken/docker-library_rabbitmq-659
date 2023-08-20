.PHONY: build up down check

DOCKER_FRESH ?= false

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

up:
ifeq ($(DOCKER_FRESH),true)
	docker compose build --no-cache --pull
	docker compose up --pull always
else
	docker compose build
	docker compose up
endif

down:
	docker compose down

check:
	set -eux; \
		container_id="$$(docker compose ps -q rabbitmq)" && \
		docker exec "$$container_id" rabbitmqctl authenticate_user $(RABBITMQ_USER) $(RABBITMQ_PASS)
