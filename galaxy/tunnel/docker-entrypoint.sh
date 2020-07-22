#!/bin/sh

set -ex

patch_conf() {
  defined_envs=$(printf '${%s} ' $(env | cut -d= -f1))
  envsubst "$defined_envs" < "$OPENVPN_DIR/server.conf.template" > "$OPENVPN_DIR/server.conf"
}

if [ ! -f "$GALAXY_INITIALIZED_MARK" ]; then
  patch_conf
  touch $GALAXY_INITIALIZED_MARK
  echo
  echo 'openvpn init process complete; ready for start up.'
  echo
else
  echo
  echo 'Skipping initialization'
  echo
fi
 
mkdir -p $OVPN_IP_POOL_DIR

if [ "$RUN_AFTER_SIDECAR" = "yes" ]; then
	until wget --spider localhost:15000 > /dev/null; do echo '>>> Waiting for sidecar'; sleep 2 ; done ; echo '>>> Sidecar available';sleep 5;
fi
/bin/sh -c "$@"
