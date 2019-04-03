#!/bin/sh

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo "Starting"

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

    wget https://${IDRAC_HOST}:${IDRAC_PORT}/software/avctKVM.jar --no-check-certificate

    if [ ! $? -eq 0 ]; then
        echo "${RED}Failed to download avctKVM.jar, please check your settings${NC}"
        sleep 2
        exit 2
    fi
fi

if [ ! -f lib/avctKVMIOLinux64.jar ]; then
    echo "Downloading avctKVMIOLinux64"

    wget -O lib/avctKVMIOLinux64.jar https://${IDRAC_HOST}:${IDRAC_PORT}/software/avctKVMIOLinux64.jar --no-check-certificate

    if [ ! $? -eq 0 ]; then
        echo "${RED}Failed to download avctKVMIOLinux64.jar, please check your settings${NC}"
        sleep 2
        exit 2
    fi
fi

if [ ! -f lib/avctVMLinux64.jar ]; then
    echo "Downloading avctVMLinux64"

    wget -O lib/avctVMLinux64.jar https://${IDRAC_HOST}:${IDRAC_PORT}/software/avctVMLinux64.jar --no-check-certificate

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

exec java -cp avctKVM.jar -Djava.library.path="./lib" com.avocent.idrac.kvm.Main ip=${IDRAC_HOST} kmport=5900 vport=5900 user=${IDRAC_USER} passwd=${IDRAC_PASSWORD} apcp=1 version=2 vmprivilege=true "helpurl=https://${IDRAC_HOST}:443/help/contents.html"
