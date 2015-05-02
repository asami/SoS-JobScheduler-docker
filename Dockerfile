FROM dockerfile/java:oracle-java8
MAINTAINER asami

ENV JOBSCHEDULER_VERSION 1.9.0-RC1

RUN apt-get update && apt-get -y install wget

RUN cd /opt; wget http://freefr.dl.sourceforge.net/project/jobscheduler/jobscheduler_linux-x64.$JOBSCHEDULER_VERSION.tar.gz -O jobscheduler_linux-x64.tar.gz

RUN cd /opt; /bin/tar -zxvf jobscheduler_linux-x64.tar.gz

# SSH, API/HTTP, API/HTTPS, JOC
EXPOSE 22 44440 8443 4444

USER root

COPY scheduler_install.xml /opt/jobscheduler.$JOBSCHEDULER_VERSION/scheduler_install.xml

# Set the default command to run when starting the container
COPY startup-jobscheduler.sh /opt/startup-jobscheduler.sh
CMD ["/opt/startup-jobscheduler.sh"]
