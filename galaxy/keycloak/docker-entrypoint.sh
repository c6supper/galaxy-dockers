#!/bin/sh

set -ex

patch_conf() {
  echo "initialization"
}

# //todo need to wait for keycloak-init ready
# $GALAXY_DIR/liveness_probe.sh $GALAXY_POSTGRES_HOST $GALAXY_POSTGRES_PORT

if [ ! -f "$GALAXY_INITIALIZED_MARK" ]; then
  patch_conf
  touch $GALAXY_INITIALIZED_MARK
  echo
  echo 'keycloak init complete; ready for start up.'
  echo
else
  echo
  echo 'Skipping initialization'
  echo
fi

/bin/sh -c /opt/jboss/tools/docker-entrypoint.sh -b 0.0.0.0
