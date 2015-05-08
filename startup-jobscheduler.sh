#! /bin/bash

# set -x

set -e

sleep 10s

echo CONTAINER_NAME: ${CONTAINER_NAME:=${0##*/}}
echo DB_SERVER_DBMS: ${DB_SERVER_DBMS:=mysql}
echo DB_SERVER_HOST: ${DB_SERVER_HOST:=$DB_PORT_3306_TCP_ADDR}
echo DB_SERVER_PORT: ${DB_SERVER_PORT:=$DB_PORT_3306_TCP_PORT}
echo DB_SERVER_USER: ${DB_SERVER_USER:=jobscheduler}
echo DB_SERVER_PASSWORD: ${DB_SERVER_PASSWORD:=jobscheduler}
echo DB_SERVER_DATABASE: ${DB_SERVER_DATABASE:=jobscheduler}
echo REDIS_SERVER_HOST: ${REDIS_SERVER_HOST:=$REDIS_PORT_6379_TCP_ADDR}
echo REDIS_SERVER_PORT: ${REDIS_SERVER_PORT:=$REDIS_PORT_6379_TCP_PORT}
echo WAIT_CONTAINER_KEY: ${WAIT_CONTAINER_KEY:=$CONTAINER_NAME}

function wait_container {
    if [ -n "$REDIS_SERVER_HOST" ]; then
	wait_container_redis
    fi
}

function wait_container_redis {
    result=1
    for i in $(seq 1 ${WAIT_CONTAINER_TIMER:-100})
    do
	sleep 1s
	result=0
	if [ $(redis-cli -h $REDIS_SERVER_HOST -p $REDIS_SERVER_PORT GET $WAIT_CONTAINER_KEY)'' = "up" ]; then
	    break
	fi
	echo $CONTAINER_NAME wait: $REDIS_SERVER_HOST
	result=1
    done
    if [ $result = 1 ]; then
	exit 1
    fi
}

sed -i -e "s/{{DB_SERVER_DBMS}}/$DB_SERVER_DBMS/g" /opt/jobscheduler/scheduler_install.xml
sed -i -e "s/{{DB_SERVER_HOST}}/$DB_SERVER_HOST/g" /opt/jobscheduler/scheduler_install.xml
sed -i -e "s/{{DB_SERVER_PORT}}/$DB_SERVER_PORT/g" /opt/jobscheduler/scheduler_install.xml
sed -i -e "s/{{DB_SERVER_USER}}/$DB_SERVER_USER/g" /opt/jobscheduler/scheduler_install.xml
sed -i -e "s/{{DB_SERVER_PASSWORD}}/$DB_SERVER_PASSWORD/g" /opt/jobscheduler/scheduler_install.xml
sed -i -e "s/{{DB_SERVER_DATABASE}}/$DB_SERVER_DATABASE/g" /opt/jobscheduler/scheduler_install.xml

wait_container

(cd /opt/jobscheduler;/usr/bin/java -jar jobscheduler_linux-x64.$JOBSCHEDULER_VERSION.jar scheduler_install.xml)

sleep infinity
