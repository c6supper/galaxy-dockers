#!/bin/sh

set -ex

patch_conf() {
  export PGPASSWORD=$GALAXY_POSTGRES_PASSWORD
  while true
  do
      if psql -h $GALAXY_POSTGRES_HOST -U $GALAXY_POSTGRES_USER -l | awk '{ print $1 }' | grep -qw $GALAXY_CLIENT_DB; then
          if psql -h $GALAXY_POSTGRES_HOST -U $GALAXY_POSTGRES_USER -d $GALAXY_CLIENT_DB -t -c '\du' | cut -d \| -f 1 | grep -qw $GALAXY_OPENRESTY_USER; then
              echo "$GALAXY_OPENRESTY_USER is existed."
          else
              psql -h $GALAXY_POSTGRES_HOST -U $GALAXY_POSTGRES_USER -d $GALAXY_CLIENT_DB <<-EOSQL
                CREATE USER $GALAXY_OPENRESTY_USER WITH PASSWORD '$GALAXY_OPENRESTY_PASSWORD';
                GRANT SELECT,INSERT,UPDATE,DELETE ON ALL TABLES IN SCHEMA public TO $GALAXY_OPENRESTY_USER;
                GRANT SELECT,USAGE ON ALL SEQUENCES IN SCHEMA public TO $GALAXY_OPENRESTY_USER;
                ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT, UPDATE, INSERT, DELETE, TRIGGER ON TABLES TO $GALAXY_OPENRESTY_USER;
EOSQL
          fi
          break;
      fi
  done
  defined_envs=$(printf '${%s} ' $(env | cut -d= -f1))
  envsubst "$defined_envs" < "/usr/local/openresty/nginx/conf/conf.d/server.conf.template" > "/usr/local/openresty/nginx/conf/conf.d/server.conf"
  envsubst "$defined_envs" < "/usr/local/openresty/nginx/conf/nginx.conf.template" > "/usr/local/openresty/nginx/conf/nginx.conf"
  envsubst "$defined_envs" < "/usr/local/openresty/nginx/conf/lua/connect_postgres.lua.template" > "/usr/local/openresty/nginx/conf/lua/connect_postgres.lua"
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
