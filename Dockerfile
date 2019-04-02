FROM jlesage/baseimage-gui:ubuntu-16.04

ENV APP_NAME="iDRAC 6" \
    IDRAC_PORT=443

COPY keycode-hack.c /keycode-hack.c

RUN apt-get update && \
    apt-get install -y wget software-properties-common && \
    add-apt-repository ppa:openjdk-r/ppa && \
    apt-get update && \
    apt-get install -y openjdk-7-jdk gcc && \
    gcc -o /keycode-hack.so /keycode-hack.c -shared -s -ldl -fPIC && \
    apt-get remove -y gcc wget software-properties-common && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* && \
    rm /keycode-hack.c

RUN mkdir /app && \
    chown ${USER_ID}:${GROUP_ID} /app

COPY startapp.sh /startapp.sh

WORKDIR /app
