FROM jlesage/baseimage-gui:debian-11

ENV APP_NAME="iDRAC 6"  \
    IDRAC_PORT=443      \
    DISPLAY_WIDTH=801   \
    DISPLAY_HEIGHT=621

COPY keycode-hack.c /keycode-hack.c

RUN APP_ICON_URL=https://raw.githubusercontent.com/DomiStyle/docker-idrac6/master/icon.png && \
    install_app_icon.sh "$APP_ICON_URL"

RUN apt-get update && \
    apt-get install -y wget software-properties-common libx11-dev gcc xdotool curl && \
    wget -nc https://corretto.aws/downloads/latest/amazon-corretto-8-x64-linux-jdk.deb && \
    apt-get install -y ./amazon-corretto-8-x64-linux-jdk.deb && \
    gcc -o /keycode-hack.so /keycode-hack.c -shared -s -ldl -fPIC && \
    apt-get remove -y gcc software-properties-common && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* && \
    rm /keycode-hack.c

RUN mkdir /app && \
    chown ${USER_ID}:${GROUP_ID} /app

RUN perl -i -pe 's/^(\h*jdk\.tls\.disabledAlgorithms\h*=\h*)([\w.\h<>\n\\,]*)(TLSv1[,\n\h]\h*)/$1$2/m' /usr/lib/jvm/java-1.8.0-amazon-corretto/jre/lib/security/java.security

COPY startapp.sh /startapp.sh
COPY mountiso.sh /mountiso.sh

WORKDIR /app
