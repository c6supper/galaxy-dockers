
## Galaxy client docker
**A Java Servlet and Guacamole-Client Dockerfile.**  

## How to build
1. **Build guacamole-client, move the target jar to current directory.**
2. **Export tomcat profiles to directory "etc/tomcat"**
3. **Export client profiles to directory "etc/guacamole"**
4. **Copy guacamole-client database schema SQL to directory "./schema"**
5. **Debug, docker build --no-cache -t c6supper/galaxy-client -f Dockerfile --build-arg LIVENESS_PROBE="$(cat ../../build-env/tcp-port-wait.sh)" ./**
6. **Release, "../../build-env/build.sh c6supper galaxy-client release", the built image will be push to c6supper repositories as default.**