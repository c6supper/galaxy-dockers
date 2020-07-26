
# Use alphine as base for the build
ARG ALPINE_VERSION=3.12
FROM alpine:${ALPINE_VERSION}

MAINTAINER calvin <c6supper@hotmail.com>

ENV GALAXY_DIR /galaxy
ENV GALAXY_INITIALIZED_MARK $GALAXY_DIR/patched
RUN mkdir -p $GALAXY_DIR
COPY ./version $GALAXY_DIR/version
COPY ./docker-entrypoint.sh $GALAXY_DIR/docker-entrypoint.sh
ARG LIVENESS_PROBE
RUN echo "$LIVENESS_PROBE" > $GALAXY_DIR/liveness_probe.sh
RUN chmod a+x $GALAXY_DIR/liveness_probe.sh
ENV GALAXY_POSTGRES_HOST galaxy-postgres
ENV GALAXY_POSTGRES_USER galaxy-user
ENV GALAXY_POSTGRES_PASSWORD 123
ENV KEYCLOAK_DB keycloak_db
ENV KEYCLOAK_DB_USER keycloak_user
ENV KEYCLOAK_DB_PASSWORD 123
ENV KEYCLOAK_HTTP_PORT 8083
ENV GALAXY_POSTGRES_PORT 5432

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories && \
    apk add --update postgresql-client bash && \
    apk add --virtual temppkg &&  \
    apk del temppkg && \
    rm -rf /tmp/* /var/tmp/* /var/cache/apk/* /var/cache/distfiles/*

# initilization for the first time
ENTRYPOINT ["/galaxy/docker-entrypoint.sh"]

# Expose the default listener port
EXPOSE $KEYCLOAK_HTTP_PORT:8080

CMD ["while [ $? -ne 0 ]; do sleep 10 && $GALAXY_DIR/liveness_probe.sh localhost $KEYCLOAK_HTTP_PORT; done"]