
# Use tomcat as base for the build
ARG TOMCAT_VERSION=jdk8-openjdk-slim
FROM tomcat:${TOMCAT_VERSION}

RUN sed -i 's/deb.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list

RUN set -eux; \
    apt-get update; \
    apt-get install -y gettext-base netcat-traditional

RUN rm -rf /var/lib/apt/lists/*

# Copy profiles to container
COPY etc "/etc"

# Copy build artifacts into this stage
COPY ezremote.war /usr/local/tomcat/webapps/

ENV GALAXY_DIR /galaxy
ENV GALAXY_INITIALIZED_MARK $GALAXY_DIR/patched

RUN mkdir -p $GALAXY_DIR

COPY ./version $GALAXY_DIR/version
COPY ./docker-entrypoint.sh $GALAXY_DIR/docker-entrypoint.sh
COPY ./tcp-port-wait.sh $GALAXY_DIR/tcp-port-wait.sh
RUN mkdir -p $GALAXY_DIR/schema
COPY ./schema/* $GALAXY_DIR/schema/

ENV GALAXY_POSTGRES_HOST galaxy-postgres
ENV GALAXY_POSTGRES_USER galaxy-user
ENV GALAXY_POSTGRES_PASSWORD 123

ENV GALAXY_GUACD_HOST galaxy-guacd
ENV GALAXY_CLIENT_DB client_db
ENV GALAXY_CLIENT_USER client
ENV GALAXY_CLIENT_PASSWORD 123

# initilization for the first time
ENTRYPOINT ["/galaxy/docker-entrypoint.sh"]

# Expose the default listener port
EXPOSE 8080

CMD ["catalina.sh run"]
