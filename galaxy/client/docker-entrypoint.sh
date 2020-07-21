#!/bin/sh

set -ex

patch_conf() {
  defined_envs=$(printf '${%s} ' $(env | cut -d= -f1))
  apt-get update > /dev/null
  apt-get install -y postgresql-client > /dev/null
  rm -rf /var/lib/apt/lists/*

  export PGPASSWORD=$GALAXY_POSTGRES_PASSWORD
  
  createdb -h $GALAXY_POSTGRES_HOST -U $GALAXY_POSTGRES_USER $GALAXY_CLIENT_DB
  cat $GALAXY_DIR/schema/*.sql | psql -h $GALAXY_POSTGRES_HOST -U $GALAXY_POSTGRES_USER -d $GALAXY_CLIENT_DB -f -
  psql -h $GALAXY_POSTGRES_HOST -U $GALAXY_POSTGRES_USER -d $GALAXY_CLIENT_DB <<-EOSQL
	CREATE USER $GALAXY_CLIENT_USER WITH PASSWORD '$GALAXY_CLIENT_PASSWORD';
	GRANT SELECT,INSERT,UPDATE,DELETE ON ALL TABLES IN SCHEMA public TO $GALAXY_CLIENT_USER;
	GRANT SELECT,USAGE ON ALL SEQUENCES IN SCHEMA public TO $GALAXY_CLIENT_USER;
EOSQL

  envsubst "$defined_envs" < "/etc/guacamole/guacamole.properties.template" > "/etc/guacamole/guacamole.properties"
  apt-get remove -y postgresql-client > /dev/null
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
