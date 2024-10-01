FROM mcr.microsoft.com/dotnet/runtime-deps:9.0-noble

ARG NADEKOBOT_VERSION
ARG ARCH=x64
ARG BUILD_DATE=$(date)
ENV UID=99
ENV GID=100

LABEL build_version="Build by D3lta | NadekoBot version:- ${NADEKOBOT_VERSION} | Build-date:- ${BUILD_DATE}"
LABEL maintainer="d3lta"

ENV DEBIAN_FRONTEND="noninteractive"
ENV NadekoBot__creds=/config/creds.yml

RUN \
    echo "*** install runtime ***" && \
    apt update -y \
    && apt install -y --no-install-recommends \
    sudo \
    lsb-release \
    gpg-agent \
    software-properties-common \
    wget \
    curl \
    xz-utils \
    jq \
    unzip \
    git \
    yt-dlp \
    tar \
    ffmpeg && \
    rm -rf \
    /var/lib/apt/lists/* \
    /var/tmp/*

### ### S6 Overlay ### ###
ARG S6_OVERLAY_VERSION=3.2.0.0

ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-x86_64.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-x86_64.tar.xz

ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-symlinks-noarch.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-symlinks-noarch.tar.xz
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-symlinks-arch.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-symlinks-arch.tar.xz

ADD ./root/ /
### ### ### ### ### ###

# https://gitlab.com/Kwoth/nadekobot/-/releases
# https://gitlab.com/api/v4/projects/9321079/packages/generic/NadekoBot-build/5.1.10/5.1.10-linux-x64-build.tar
# https://gitlab.com/api/v4/projects/9321079/packages/generic/NadekoBot-build/5.1.10/5.1.10-linux-arm64-build.tar

ADD --chmod=644 https://gitlab.com/api/v4/projects/9321079/packages/generic/NadekoBot-build/${NADEKOBOT_VERSION}/${NADEKOBOT_VERSION}-linux-${ARCH}-build.tar /tmp
RUN \
    mkdir -p /app && \
    tar -xvf "/tmp/${NADEKOBOT_VERSION}-linux-${ARCH}-build.tar" -C /tmp && \
    mv /tmp/nadekobot-linux-x64/** /app/ && \
    chmod 755 /etc/s6-overlay/s6-rc.d/*/run && \
    chmod 755 /etc/s6-overlay/s6-rc.d/*/up

VOLUME /config /data

ENTRYPOINT ["/init"]
