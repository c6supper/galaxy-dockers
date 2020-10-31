
# Use alphine as base for the build
ARG OPENRESTY_TAG=alpine
FROM openresty/openresty:${OPENRESTY_TAG}

MAINTAINER calvin <c6supper@hotmail.com>

# init nginx configuration
COPY ./nginx /usr/local/openresty/nginx/conf
COPY ./lua-resty-postgres/lib/resty/postgres.lua /usr/local/openresty/lualib/resty/

ENV GALAXY_DIR /galaxy
ENV GALAXY_INITIALIZED_MARK $GALAXY_DIR/patched
RUN mkdir -p $GALAXY_DIR
COPY ./version $GALAXY_DIR/version
COPY ./docker-entrypoint.sh $GALAXY_DIR/docker-entrypoint.sh
ENV GALAXY_CLIENT_HOST galaxy-client
ENV GALAXY_TUNNEL_HOST galaxy-tunnel
ENV GALAXY_KEYCLOAK_HOST galaxy-keycloak
ENV GALAXY_CLIENT_DB guacamole_db
ENV GALAXY_CLIENT_USER guacamole_user
ENV GALAXY_CLIENT_PASSWORD 123
ENV GALAXY_POSTGRES_HOST galaxy-postgres
ENV GALAXY_OPENRESTY_RESOLVER 127.0.0.11
ENV GALAXY_PEERJS_HOST galaxy-peerjs
ENV GALAXY_PEERJS_PORT 9000
ENV GALAXY_CHAT_HOST galaxy-rocketchat
ENV GALAXY_CHAT_PORT 3000

ARG LIVENESS_PROBE
RUN echo "$LIVENESS_PROBE" > $GALAXY_DIR/liveness_probe.sh
RUN chmod a+x $GALAXY_DIR/liveness_probe.sh

# install gettext to support envsubst
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories && \
    apk add --update gettext bash && \
    apk add --virtual temppkg &&  \
    apk del temppkg && \
    rm -rf /tmp/* /var/tmp/* /var/cache/apk/* /var/cache/distfiles/*

# initilization for the first time
ENTRYPOINT ["/galaxy/docker-entrypoint.sh"]

# Expose the default listener port
EXPOSE 80 443

#CMD ["/usr/local/openresty/bin/openresty", "-g", "daemon off;"]
CMD ["nginx"]
