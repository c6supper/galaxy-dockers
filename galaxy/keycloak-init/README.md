
## Galaxy keycloak initialization docker
**Initialize database/backup realm/monitor keycloak.**  

## How to build
1. **Debug, docker build --no-cache -t c6supper/galaxy-keycloak-init -f Dockerfile --build-arg LIVENESS_PROBE="$(cat ../../build-env/tcp-port-wait.sh)" ./**
2. **Release, "../../build-env/build.sh c6supper galaxy-keycloak-init release", the built image will be push to c6supper repositories as default.**