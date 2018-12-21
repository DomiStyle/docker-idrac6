FROM jlesage/baseimage-gui:ubuntu-16.04

ENV APP_NAME="iDRAC 6" \
    IDRAC_PORT=443

RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:openjdk-r/ppa && \
    apt-get update && \
    apt-get install -y openjdk-7-jdk && \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir /app && \
    chown ${USER_ID}:${GROUP_ID} /app

COPY startapp.sh /startapp.sh

WORKDIR /app
