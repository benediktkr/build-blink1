#!/bin/bash

set -e

(
    cd /usr/local/dist/
    mkdir -v bin target

    cp -v /usr/local/src/blink1-tool/blink1-tool bin/
    cp -v /usr/local/src/blink1-tool/blink1-tiny-server bin/

    VERSION=$(bin/blink1-tool --version | awk  '{print $3}' | cut -d'-' -f1 | sed -e '1s/^v//')
    echo "version: $VERSION"

    set -x
    fpm \
        -t deb \
        --deb-default etc/blink1-tiny-server \
        --deb-systemd etc/blink1-tiny-server.service \
        --deb-systemd-auto-start \
        --deb-systemd-enable \
        --deb-systemd-restart-after-upgrade \
        --deb-auto-config-files \
        --config-files /etc/udev/rules.d/21-blink1.rules \
        --after-install after-install.sh \
        -n blink1 \
        -v ${VERSION} \
        -a $(dpkg --print-architecture) \
        -s dir bin/=/usr/local/bin/ etc/21-blink1.rules=/etc/udev/rules.d/21-blink1.rules

    mv -v *.deb target/
)

tree /usr/local/dist/

# dpkg-deb -I /usr/local/dist/target/*.deb
dpkg-deb -c /usr/local/dist/target/*.deb
