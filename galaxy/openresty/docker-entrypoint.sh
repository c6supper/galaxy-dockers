#!/bin/sh

set -ex

patch_conf() {
  defined_envs=$(printf '${%s} ' $(env | cut -d= -f1))
  envsubst "$defined_envs" < "/usr/local/openresty/nginx/conf/conf.d/server.conf.template" > "/usr/local/openresty/nginx/conf/conf.d/server.conf"
  envsubst "$defined_envs" < "/usr/local/openresty/nginx/conf/nginx.conf.template" > "/usr/local/openresty/nginx/conf/nginx.conf"
}

$GALAXY_DIR/liveness_probe.sh $GALAXY_CLIENT_HOST 8080

if [ ! -f "$GALAXY_INITIALIZED_MARK" ]; then
  patch_conf
  mkdir -p /var/lib/nginx/body
  touch $GALAXY_INITIALIZED_MARK
  apk del gettext
  rm -rf /tmp/* /var/tmp/* /var/cache/apk/* /var/cache/distfiles/*
  echo
  echo 'openvpn init process complete; ready for start up.'
  echo
else
  echo
  echo 'Skipping initialization'
  echo
fi

/bin/sh -c "$@"
