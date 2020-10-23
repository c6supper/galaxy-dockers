
## Galaxy peerjs-server docker
**chat p2p server.**  

## How to build
1. **Debug, docker build --no-cache -t c6supper/galaxy-peerjs -f Dockerfile --build-arg LIVENESS_PROBE="$(cat ../../build-env/tcp-port-wait.sh)" ./**
2. **Release, "../../build-env/build.sh c6supper galaxy-peerjs release", the built image will be push to c6supper repositories as default.**
