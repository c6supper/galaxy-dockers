
#!/bin/sh

set -ex

if [ "$#" -lt  "2" ]
  then
    echo "You have not input the user and image."
    exit
fi

# Retries a command on failure.
# $1 - the max number of attempts
# $2... - the command to run

retry() {
    local -r -i max_attempts="$1"; shift
    local -i attempt_num=1
    until "$@"
    do
        if ((attempt_num==max_attempts))
        then
            echo "Attempt $attempt_num failed and there are no more attempts left!"
            return 1
        else
            echo "Attempt $attempt_num failed! Trying again in $attempt_num seconds..."
            sleep $((attempt_num++))
        fi
    done
}

NAME=$1
IMAGE=$2

if [ "$#" -lt  "3" ]
  then
    shift 2
  else
    shift 3
fi

version=$(cat version)
echo "version: $version"
DIR="$(dirname "$(readlink -f "$0")")"

docker build --no-cache -t $NAME/$IMAGE -t $NAME/$IMAGE:$version ./ --build-arg LIVENESS_PROBE="$(cat ${DIR}/tcp-port-wait.sh)" "$@"

if [ "$#" -ge  "2" ]
  then
    docker login
    retry 100 docker push $NAME/$IMAGE:latest
    retry 100 docker push $NAME/$IMAGE:$version
fi

