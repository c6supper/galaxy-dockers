
## Galaxy rocket.chat docker
**chat server.**  

## How to build
1. **Debug, docker build --no-cache -t c6supper/galaxy-rocketchat -f Dockerfile --build-arg LIVENESS_PROBE="$(cat ../../build-env/tcp-port-wait.sh)" ./**
2. **Release, "../../build-env/build.sh c6supper galaxy-rocketchat release", the built image will be push to c6supper repositories as default.**
