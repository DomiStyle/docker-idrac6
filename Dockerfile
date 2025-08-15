FROM jlesage/baseimage-gui:debian-11-v4

ENV APP_NAME="iDRAC 6"  \
    IDRAC_PORT=443      \
    DISPLAY_WIDTH=801   \
    DISPLAY_HEIGHT=621

COPY keycode-hack.c /keycode-hack.c

RUN APP_ICON_URL=https://raw.githubusercontent.com/DomiStyle/docker-idrac6/master/icon.png && \
    install_app_icon.sh "$APP_ICON_URL"

RUN apt-get update && \
    apt-get install -y wget software-properties-common libx11-dev gcc xdotool gnupg ca-certificates curl && \
    curl -s https://repos.azul.com/azul-repo.key | gpg --dearmor -o /usr/share/keyrings/azul.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/azul.gpg] https://repos.azul.com/zulu/deb stable main" | tee /etc/apt/sources.list.d/zulu.list && \
    apt-get update && \
    apt-get install -y zulu8-jre && \
    gcc -o /keycode-hack.so /keycode-hack.c -shared -s -ldl -fPIC && \
    apt-get remove -y gcc software-properties-common gnupg ca-certificates curl && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* && \
    rm /keycode-hack.c

RUN mkdir /app && \
    chown ${USER_ID}:${GROUP_ID} /app

RUN find /usr/lib/jvm/ -name "java.security" -exec rm {} \;

COPY startapp.sh /startapp.sh
COPY mountiso.sh /mountiso.sh

WORKDIR /app