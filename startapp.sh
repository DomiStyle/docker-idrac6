#!/bin/sh

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo "Starting"

if [ -f "/run/secrets/idrac_host" ]; then
    echo "Using Docker secret for IDRAC_HOST"
    IDRAC_HOST="$(cat /run/secrets/idrac_host)"
fi

if [ -f "/run/secrets/idrac_port" ]; then
    echo "Using Docker secret for IDRAC_PORT"
    IDRAC_PORT="$(cat /run/secrets/idrac_port)"
fi

if [ -f "/run/secrets/idrac_user" ]; then
    echo "Using Docker secret for IDRAC_USER"
    IDRAC_USER="$(cat /run/secrets/idrac_user)"
fi

if [ -f "/run/secrets/idrac_password" ]; then
    echo "Using Docker secret for IDRAC_PASSWORD"
    IDRAC_PASSWORD="$(cat /run/secrets/idrac_password)"
fi

CURL_OPTS=""
JAVA_OPTS=""
if [ -n "${SOCKS_PROXY_HOST}" ]; then
    CURL_OPTS="$CURL_OPTS -x socks5://$SOCKS_PROXY_HOST:$SOCKS_PROXY_PORT"
    JAVA_OPTS="-DsocksProxyHost=$SOCKS_PROXY_HOST -DsocksProxyPort=$SOCKS_PROXY_PORT"
fi

if [ -z "${IDRAC_HOST}" ]; then
    echo "${RED}Please set a proper idrac host with IDRAC_HOST${NC}"
    sleep 2
    exit 1
fi

if [ -z "${IDRAC_PORT}" ]; then
    echo "${RED}Please set a proper idrac port with IDRAC_PORT${NC}"
    sleep 2
    exit 1
fi

if [ -z "${IDRAC_USER}" ]; then
    echo "${RED}Please set a proper idrac user with IDRAC_USER${NC}"
    sleep 2
    exit 1
fi

if [ -z "${IDRAC_PASSWORD}" ]; then
    echo "${RED}Please set a proper idrac password with IDRAC_PASSWORD${NC}"
    sleep 2
    exit 1
fi

echo "Environment ok"

cd /app

if [ ! -d "lib" ]; then
    echo "Creating library folder"
    mkdir lib
fi

if [ ! -f avctKVM.jar ]; then
    echo "Downloading avctKVM"

    curl $CURL_OPTS -o avctKVM.jar https://${IDRAC_HOST}:${IDRAC_PORT}/software/avctKVM.jar -k --ciphers 'DEFAULT:!DH'

    if [ ! $? -eq 0 ]; then
        echo "${RED}Failed to download avctKVM.jar, please check your settings${NC}"
        sleep 2
        exit 2
    fi
fi

if [ ! -f lib/avctKVMIOLinux64.jar ]; then
    echo "Downloading avctKVMIOLinux64"

    curl $CURL_OPTS -o lib/avctKVMIOLinux64.jar https://${IDRAC_HOST}:${IDRAC_PORT}/software/avctKVMIOLinux64.jar -k --ciphers 'DEFAULT:!DH'

    if [ ! $? -eq 0 ]; then
        echo "${RED}Failed to download avctKVMIOLinux64.jar, please check your settings${NC}"
        sleep 2
        exit 2
    fi
fi

if [ ! -f lib/avctVMLinux64.jar ]; then
    echo "Downloading avctVMLinux64"

    curl $CURL_OPTS -o lib/avctVMLinux64.jar https://${IDRAC_HOST}:${IDRAC_PORT}/software/avctVMLinux64.jar -k --ciphers 'DEFAULT:!DH'

    if [ ! $? -eq 0 ]; then
        echo "${RED}Failed to download avctVMLinux64.jar, please check your settings${NC}"
        sleep 2
        exit 2
    fi
fi

cd lib

if [ ! -f lib/avctKVMIOLinux64.so ]; then
    echo "Extracting avctKVMIOLinux64"

    jar -xf avctKVMIOLinux64.jar
fi

if [ ! -f lib/avctVMLinux64.so ]; then
    echo "Extracting avctVMLinux64"

    jar -xf avctVMLinux64.jar
fi

cd /app

echo "${GREEN}Initialization complete, starting virtual console${NC}"

if [ -n "$IDRAC_KEYCODE_HACK" ]; then
    echo "Enabling keycode hack"

    export LD_PRELOAD=/keycode-hack.so
fi
exec java $JAVA_OPTS -cp avctKVM.jar -Djava.library.path="./lib" com.avocent.idrac.kvm.Main ip=${IDRAC_HOST} kmport=5900 vport=5900 user=${IDRAC_USER} passwd=${IDRAC_PASSWORD} apcp=1 version=2 vmprivilege=true "helpurl=https://${IDRAC_HOST}:443/help/contents.html" &

# If an iso exists at the specified location, mount it
[ -f "/vmedia/$VIRTUAL_ISO" ] && /mountiso.sh
wait

