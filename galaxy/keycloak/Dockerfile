
# Use last keycloak as image
FROM jboss/keycloak:10.0.2

MAINTAINER calvin <c6supper@hotmail.com>

USER root

ENV GALAXY_DIR /galaxy
ENV GALAXY_INITIALIZED_MARK $GALAXY_DIR/patched
RUN mkdir -p $GALAXY_DIR
COPY ./version $GALAXY_DIR/version
COPY ./docker-entrypoint.sh $GALAXY_DIR/docker-entrypoint.sh
ARG LIVENESS_PROBE
RUN echo "$LIVENESS_PROBE" > $GALAXY_DIR/liveness_probe.sh
RUN chmod a+x $GALAXY_DIR/liveness_probe.sh
ENV GALAXY_POSTGRES_HOST galaxy-postgres
ENV GALAXY_POSTGRES_USER galaxy_user
ENV GALAXY_POSTGRES_PASSWORD galaxy_123
ENV KEYCLOAK_DB keycloak_db
ENV KEYCLOAK_DB_USER keycloak_user
ENV KEYCLOAK_DB_PASSWORD 123
ENV KEYCLOAK_HTTP_PORT 8080
ENV GALAXY_POSTGRES_PORT 5432

USER 1000

# build variable, could not be moved to docker-entrypoint.sh
ENV GALAXY_KEYCLOAK_PROXY_URI keycloak

RUN  sed -i -e 's/<web-context>auth<\/web-context>/<web-context>'"$GALAXY_KEYCLOAK_PROXY_URI"'\/auth<\/web-context>/' $JBOSS_HOME/standalone/configuration/standalone.xml
RUN  sed -i -e 's/<web-context>auth<\/web-context>/<web-context>keycloak\/auth<\/web-context>/' $JBOSS_HOME/standalone/configuration/standalone-ha.xml
RUN  sed -i -e 's/name="\/"/name="\/'"$GALAXY_KEYCLOAK_PROXY_URI"'\/"/' $JBOSS_HOME/standalone/configuration/standalone.xml
RUN  sed -i -e 's/name="\/"/name="\/'"$GALAXY_KEYCLOAK_PROXY_URI"'\/"/' $JBOSS_HOME/standalone/configuration/standalone-ha.xml
RUN  sed -i -e 's/\/auth/\/'"$GALAXY_KEYCLOAK_PROXY_URI"'\/auth"/' $JBOSS_HOME/welcome-content/index.html
