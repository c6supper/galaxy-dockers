#!/bin/sh

set -ex

patch_conf() {
  echo "initialization"
}

# wait for mongo ready, comment for now, retry in command
#$GALAXY_DIR/liveness_probe.sh $GALAXY_MONGO_HOST $GALAXY_MONGO_PORT

if [ ! -f "$GALAXY_INITIALIZED_MARK" ]; then
  patch_conf
  touch $GALAXY_INITIALIZED_MARK
  echo
  echo 'rocketchat init complete; ready for start up.'
  echo
else
  echo
  echo 'Skipping initialization'
  echo
fi

/bin/sh -c "$@"
