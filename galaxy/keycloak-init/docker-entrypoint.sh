#!/bin/sh

set -ex

patch_conf() {
  defined_envs=$(printf '${%s} ' $(env | cut -d= -f1))

  export PGPASSWORD=$GALAXY_POSTGRES_PASSWORD
  if psql -h $GALAXY_POSTGRES_HOST -U $GALAXY_POSTGRES_USER -l | awk '{ print $1 }' | grep -qw $KEYCLOAK_DB; then
      echo "$GALAXY_CLIENT_DB is existed."
  else
      createdb -h $GALAXY_POSTGRES_HOST -U $GALAXY_POSTGRES_USER $KEYCLOAK_DB
      psql -h $GALAXY_POSTGRES_HOST -U $GALAXY_POSTGRES_USER -d $KEYCLOAK_DB <<-EOSQL
        CREATE USER $KEYCLOAK_DB_USER WITH PASSWORD '$KEYCLOAK_DB_PASSWORD';
        GRANT SELECT,INSERT,UPDATE,DELETE ON ALL TABLES IN SCHEMA public TO $KEYCLOAK_DB_USER;
        GRANT SELECT,USAGE ON ALL SEQUENCES IN SCHEMA public TO $KEYCLOAK_DB_USER;
EOSQL
  fi
}

$GALAXY_DIR/liveness_probe.sh $GALAXY_POSTGRES_HOST $GALAXY_POSTGRES_PORT

if [ ! -f "$GALAXY_INITIALIZED_MARK" ]; then
  patch_conf
  touch $GALAXY_INITIALIZED_MARK
  echo
  echo 'keycloak init process complete; ready for start up.'
  echo
else
  echo
  echo 'Skipping initialization'
  echo
fi

/bin/sh -c "$@"
