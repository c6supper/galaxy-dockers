
# Use alphine as base for the build
ARG OPENRESTY_TAG=alpine
FROM openresty/openresty:${OPENRESTY_TAG}

MAINTAINER calvin <c6supper@hotmail.com>

# init nginx configuration
COPY ./nginx /usr/local/openresty/nginx/conf

ENV GALAXY_DIR /galaxy
ENV GALAXY_INITIALIZED_MARK $GALAXY_DIR/patched
RUN mkdir -p $GALAXY_DIR
COPY ./version $GALAXY_DIR/version
COPY ./docker-entrypoint.sh $GALAXY_DIR/docker-entrypoint.sh
ENV GALAXY_CLIENT_HOST galaxy-client
ENV GALAXY_TUNNEL_HOST galaxy-tunnel
ENV GALAXY_KEYCLOAK_HOST galaxy-keycloak

# install gettext to support envsubst
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories && \
    apk add --update gettext && \
    apk add --virtual temppkg &&  \
    apk del temppkg && \
    rm -rf /tmp/* /var/tmp/* /var/cache/apk/* /var/cache/distfiles/*

# initilization for the first time
ENTRYPOINT ["/galaxy/docker-entrypoint.sh"]

# Expose the default listener port
EXPOSE 80 443

#CMD ["/usr/local/openresty/bin/openresty", "-g", "daemon off;"]
CMD ["nginx"]
