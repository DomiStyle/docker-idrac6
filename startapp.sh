#!/bin/sh

RED='\033[0;31m'
NC='\033[0m'

echo "Starting"

if [ -z "${IDRAC_HOST}" ]; then
    echo -e "${RED}Please set a proper idrac host with IDRAC_HOST${NC}"
    sleep 2
    exit 1
fi

if [ -z "${IDRAC_USER}" ]; then
    echo -e "${RED}Please set a proper idrac user with IDRAC_USER${NC}"
    sleep 2
    exit 1
fi

if [ -z "${IDRAC_PASSWORD}" ]; then
    echo -e "${RED}Please set a proper idrac password with IDRAC_PASSWORD${NC}"
    sleep 2
    exit 1
fi

echo "Environment ok"

echo "Creating library folder"

cd /app
mkdir lib

echo "Downloading required files"

if [ ! -f avctKVM.jar ]; then
    wget https://${IDRAC_HOST}/software/avctKVM.jar --no-check-certificate

    if [ ! $? -eq 0 ]; then
        echo -e "${RED}Failed to download avctKVM.jar, please check your settings${NC}"
        sleep 2
        exit 2
    fi
fi

if [ ! -f lib/avctKVMIOLinux64.jar ]; then
    wget -O lib/avctKVMIOLinux64.jar https://${IDRAC_HOST}/software/avctKVMIOLinux64.jar --no-check-certificate

    if [ ! $? -eq 0 ]; then
        echo -e "${RED}Failed to download avctKVMIOLinux64.jar, please check your settings${NC}"
        sleep 2
        exit 2
    fi
fi

if [ ! -f lib/avctVMLinux64.jar ]; then
    wget -O lib/avctVMLinux64.jar https://${IDRAC_HOST}/software/avctVMLinux64.jar --no-check-certificate

    if [ ! $? -eq 0 ]; then
        echo -e "${RED}Failed to download avctVMLinux64.jar, please check your settings${NC}"
        sleep 2
        exit 2
    fi
fi

exec java -cp avctKVM.jar -Djava.library.path="./lib" com.avocent.idrac.kvm.Main ip=${IDRAC_HOST} kmport=5900 vport=5900 user=${IDRAC_USER} passwd=${IDRAC_PASSWORD} apcp=1 version=2 vmprivilege=true "helpurl=https://${IDRAC_HOST}:443/help/contents.html"
