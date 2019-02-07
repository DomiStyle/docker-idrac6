FROM jlesage/baseimage-gui:alpine-3.8-glibc

ENV APP_NAME="iDRAC 6" \
    IDRAC_PORT=443 \
    HOME=/app

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
	apk update && \
	apk add --no-cache openjdk7 wget && \
	rm -rf /var/cache/apk/* && \
    mkdir /app && \
    chown ${USER_ID}:${GROUP_ID} /app

COPY startapp.sh /startapp.sh

WORKDIR /app
