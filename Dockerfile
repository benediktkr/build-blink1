FROM ubuntu:latest as base
MAINTAINER Ben K <ben@sudo.is>

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

RUN set -x && \
    apt-get update

FROM base AS builder
RUN set -x && \
    apt-get install -y ruby ruby-dev rubygems tree git libudev-dev pkg-config build-essential && \
    gem install --no-document fpm && \
    mkdir -p /usr/local/src/blink1-tool /usr/local/dist && \
    chown -R nobody:nogroup /usr/local/src/ /usr/local/dist

COPY --chown=nobody:nogroup blink1-tool /usr/local/src/blink1-tool

USER nobody
WORKDIR /usr/local/src/blink1-tool
RUN set -x && \
    make && \
    make blink1-tiny-server

COPY --chown=nobody:nogroup etc/ /usr/local/dist/etc/

COPY make_deb.sh /usr/local/bin/make_deb.sh
RUN set -x && \
    /usr/local/bin/make_deb.sh
