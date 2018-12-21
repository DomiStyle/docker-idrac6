FROM jlesage/baseimage-gui:ubuntu-16.04

ENV APP_NAME="iDRAC 6" \
    IDRAC_PORT=443

RUN apt-get update
RUN apt-get -y install software-properties-common 
RUN add-apt-repository ppa:openjdk-r/ppa  
RUN apt-get update
RUN apt-get -y install openjdk-7-jdk

RUN mkdir /app && \
    chown ${USER_ID}:${GROUP_ID} /app

COPY startapp.sh /startapp.sh

WORKDIR /app
