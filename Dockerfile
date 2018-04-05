FROM jlesage/baseimage-gui:alpine-3.7

ENV APP_NAME="iDRAC 6"

RUN apk add --no-cache openjdk7-jre

RUN mkdir /app && \
    chown ${USER_ID}:${GROUP_ID} /app

COPY startapp.sh /startapp.sh

WORKDIR /app
