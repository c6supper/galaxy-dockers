## Galaxy docker build scripts
**Galaxy related Dockerfiles and building scripts.**  

## Requirements
1. **Installed ubuntu(version >= 18.04) or centos7 amd64 version**
2. **Installed docker and docker-compose, refer to [docker](https://github.com/c6supper/galaxy-devops/blob/master/docker/README.md)**  

## Getting started
1. **"build-env" is the common docker build and release script, including a version control system and building scripts.**
2. **"client" is the Docker image which have a Tomcat and guacamole-client deployed in,refer to [client](./galaxy/client/README.md).**
3. **"keycloak" is the Docker image which support authentication and authorization,refer to [keycloak](./galaxy/keycloak/README.md).**
4. **"keycloak-init" is the init container for keycloak,refer to [keycloak-init](./galaxy/keycloak-init/README.md).**

## How to build
1. **Checkout the related resources to the building directory, and run docker build.**
2. **For the detail ,please refer to the README.md inside each sub directory.**

