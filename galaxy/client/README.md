# web client docker

* Dockerfile for web client, changed repositories to mirrors in China. 
       
* Build docker
    1.export client app to current directory
    2.export tomcat profiles to directory "etc/tomcat"
    3.export client profiles to directory "etc/guacamole"
    4.export client database schema SQL file to directory ./schema
    5.export tcp-port-wait.sh
    6.docker build --no-cache -t c6supper/galaxy-client -f Dockerfile ./
