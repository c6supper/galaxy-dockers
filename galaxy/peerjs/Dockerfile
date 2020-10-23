
FROM peerjs/peerjs-server

MAINTAINER calvin <c6supper@hotmail.com>

ENV GALAXY_DIR /galaxy
ENV GALAXY_INITIALIZED_MARK $GALAXY_DIR/patched
RUN mkdir -p $GALAXY_DIR
COPY ./version $GALAXY_DIR/version
COPY ./docker-entrypoint.sh $GALAXY_DIR/docker-entrypoint.sh

ARG LIVENESS_PROBE
RUN echo "$LIVENESS_PROBE" > $GALAXY_DIR/liveness_probe.sh
RUN chmod a+x $GALAXY_DIR/liveness_probe.sh

ENV GALAXY_PEERJS_PORT 9000
ENV GALAXY_PEERJS_URI  /ezremote
ENV GALAXY_PEERJS_PROXIED  false
ENV GALAXY_PEERJS_DISCOVERIED  true

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories && \
    apk add --update bash && \
    apk add --virtual temppkg &&  \
    apk del temppkg && \
    rm -rf /tmp/* /var/tmp/* /var/cache/apk/* /var/cache/distfiles/*

EXPOSE $GALAXY_PEERJS_PORT
ENTRYPOINT ["/galaxy/docker-entrypoint.sh"]
CMD [ "node bin/peerjs --port $GALAXY_PEERJS_PORT --path $GALAXY_PEERJS_URI --proxied $GALAXY_PEERJS_PROXIED --allow_discovery $GALAXY_PEERJS_DISCOVERIED" ]
