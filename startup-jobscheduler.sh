#! /bin/bash

sleep 10s

sed -i -e "s/{{DB_PORT_3306_TCP_ADDR}}/$DB_PORT_3306_TCP_ADDR/g" /opt/jobscheduler.$JOBSCHEDULER_VERSION/scheduler_install.xml
sed -i -e "s/{{DB_PORT_3306_TCP_PORT}}/$DB_PORT_3306_TCP_PORT/g" /opt/jobscheduler.$JOBSCHEDULER_VERSION/scheduler_install.xml

(cd /opt/jobscheduler.$JOBSCHEDULER_VERSION;/usr/bin/java -jar jobscheduler_linux-x64.$JOBSCHEDULER_VERSION.jar scheduler_install.xml)

sleep infinity
