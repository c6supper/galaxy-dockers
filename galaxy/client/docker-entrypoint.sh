#!/bin/sh

set -ex

patch_conf() {
  export PGPASSWORD=$GALAXY_POSTGRES_PASSWORD
  if psql -h $GALAXY_POSTGRES_HOST -U $GALAXY_POSTGRES_USER -l | awk '{ print $1 }' | grep -qw $GALAXY_CLIENT_DB; then
      echo "$GALAXY_CLIENT_DB is existed."
  else
      createdb -h $GALAXY_POSTGRES_HOST -U $GALAXY_POSTGRES_USER $GALAXY_CLIENT_DB
      cat $GALAXY_DIR/schema/*.sql | psql -h $GALAXY_POSTGRES_HOST -U $GALAXY_POSTGRES_USER -d $GALAXY_CLIENT_DB -f -
      psql -h $GALAXY_POSTGRES_HOST -U $GALAXY_POSTGRES_USER -d $GALAXY_CLIENT_DB <<-EOSQL
        CREATE USER $GALAXY_CLIENT_USER WITH PASSWORD '$GALAXY_CLIENT_PASSWORD';
        GRANT SELECT,INSERT,UPDATE,DELETE ON ALL TABLES IN SCHEMA public TO $GALAXY_CLIENT_USER;
        GRANT SELECT,USAGE ON ALL SEQUENCES IN SCHEMA public TO $GALAXY_CLIENT_USER;
        CREATE USER $GALAXY_OPENRESTY_USER WITH PASSWORD '$GALAXY_OPENRESTY_PASSWORD';
        GRANT SELECT,INSERT,UPDATE,DELETE ON ALL TABLES IN SCHEMA public TO $GALAXY_OPENRESTY_USER;
        GRANT SELECT,USAGE ON ALL SEQUENCES IN SCHEMA public TO $GALAXY_OPENRESTY_USER;
EOSQL
  fi

  export GALAXY_AUTH_EP=$GALAXY_AUTH_URL/$GALAXY_AUTH_URI/auth/realms/VeEX/protocol/openid-connect/auth
  export GALAXY_JWKS_EP=$GALAXY_AUTH_URL/$GALAXY_AUTH_URI/auth/realms/VeEX/protocol/openid-connect/certs
  export GALAXY_ISSUER=$GALAXY_AUTH_URL/$GALAXY_AUTH_URI/auth/realms/VeEX
  export GALAXY_REDIRECT_URI=$GALAXY_AUTH_URL/

  defined_envs=$(printf '${%s} ' $(env | cut -d= -f1))
  envsubst "$defined_envs" < "/etc/guacamole/guacamole.properties.template" > "/etc/guacamole/guacamole.properties"
}

$GALAXY_DIR/liveness_probe.sh $GALAXY_POSTGRES_HOST 5432

if [ ! -f "$GALAXY_INITIALIZED_MARK" ]; then
  patch_conf
  touch $GALAXY_INITIALIZED_MARK
  echo
  echo 'tomcat init process complete; ready for start up.'
  echo
else
  echo
  echo 'Skipping initialization'
  echo
fi

/bin/sh -c "$@"
