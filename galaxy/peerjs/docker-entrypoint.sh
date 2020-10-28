#!/bin/sh

set -ex

patch_conf() {
  echo "initialization"
  defined_envs=$(printf '${%s} ' $(env | cut -d= -f1))
}

# //todo need to wait for keycloak-init ready
# $GALAXY_DIR/liveness_probe.sh $GALAXY_POSTGRES_HOST $GALAXY_POSTGRES_PORT

if [ ! -f "$GALAXY_INITIALIZED_MARK" ]; then
  patch_conf
  touch $GALAXY_INITIALIZED_MARK
  echo
  echo 'peerjs complete; ready for start up.'
  echo
else
  echo
  echo 'Skipping initialization'
  echo
fi

/bin/sh -c "$@"
