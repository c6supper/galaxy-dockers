#!/bin/bash
set -e 

if [ -z "$1" -o -z "$2" ]
then
    echo "tcp-port-wait - block until specified TCP port becomes available"
    echo -e "Usage: \n\t./tcp-port-wait.sh HOST PORT"
    exit 1
fi
echo Waiting for port $1:$2 to become available...
while ! nc -z $1 $2 2>/dev/null
do
    sleep 1;
done

sleep 5
echo "READY !"
