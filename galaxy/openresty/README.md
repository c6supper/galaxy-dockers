#   openresty docker
#   openresty version:1.17.8.1
#   nginx version:1.17.8

* Dockerfile for openresty, changed repositories to mirrors in China. 
       
* Build docker
    1.export nginx profiles to directory "nginx"
    2.git clone postgres.lua from https://github.com/azurewang/lua-resty-postgres.git
    3.docker build --no-cache -t c6supper/galaxy-openresty -f Dockerfile ./
    
* Build release docker
    1. change the version
    2. ../../build-env/build.sh c6supper galaxy-openresty release
