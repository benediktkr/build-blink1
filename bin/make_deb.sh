#!/bin/bash

set -e

cp -v /usr/local/src/blink1-tool/blink1-tool /usr/local/src/deb/bin/
cp -v /usr/local/src/blink1-tool/blink1-tiny-server /usr/local/src/deb/bin/

NAME=blink1
ARCH=$(dpkg --print-architecture)
BLINK1_VERSION=$(/usr/local/src/deb/bin/blink1-tool --version | awk  '{print $3}' | cut -d'-' -f1 | sed -e '1s/^v//')
VERSION=${BLINK1_VERSION}-$(date -I)
echo "version: $VERSION"

# we should already be here
cd /usr/local/src

set -x
fpm \
    -t deb \
    -d libudev-dev \
    --deb-systemd etc/blink1-tiny-server.service \
    --deb-systemd-auto-start \
    --deb-systemd-enable \
    --deb-systemd-restart-after-upgrade \
    --deb-auto-config-files \
    --deb-user nobody \
    --deb-group nobody \
    --deb-default etc/blink1-tiny-server \
    --config-files /etc/udev/rules.d/21-blink1.rules \
    --after-install deb/after-install.sh \
    --maintainer "sudo.is <pkg@sudo.is>" \
    --vendor "blink1-tool (https://github.com/todbot/blink1-tool), package by sudo.is" \
    --url "https://git.sudo.is/ben/build-blink1" \
    --license "MIT" \
    --description "Simple builds of blink1-tool and blink1-tiny-server" \
    -p ./dist/ \
    -n ${NAME} \
    -v ${VERSION} \
    -a ${ARCH} \
    -s dir deb/bin/=/usr/local/bin/ etc/21-blink1.rules=/etc/udev/rules.d/21-blink1.rules

echo $VERSION > /usr/local/src/dist/blink1_version.txt
echo ${NAME}_${VERSION}_${ARCH}.deb > /usr/local/src/dist/debfile.txt
tree /usr/local/src/dist/ /usr/local/src/deb/

dpkg-deb -I /usr/local/src/dist/*.deb
dpkg-deb -c /usr/local/src/dist/*.deb

# linux-vdso is statically linked, only libudev-dev is needed as dependency
ldd /usr/local/src/deb/bin/blink1-tool
ldd /usr/local/src/deb/bin/blink1-tiny-server


