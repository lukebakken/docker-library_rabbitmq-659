FROM rabbitmq:management-alpine
ARG BUILD_ENV=DEV

RUN echo "BUILD_ENV: $BUILD_ENV"

WORKDIR /etc/rabbitmq
COPY --chown=rabbitmq:rabbitmq rabbitmq.conf .

WORKDIR /etc/rabbitmq/defs.d
COPY --chown=rabbitmq:rabbitmq definitions.json 10-definitions.json
COPY --chown=rabbitmq:rabbitmq definitions-${BUILD_ENV}.json 20-definitions-${BUILD_ENV}.json 
