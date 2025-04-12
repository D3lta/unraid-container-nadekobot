FROM mcr.microsoft.com/dotnet/runtime-deps:9.0-noble

ARG NADEKOBOT_VERSION=5.3.9
ARG ARCH=x64
ARG S6_OVERLAY_VERSION=3.2.0.2

LABEL build_version="NadekoBot version:- ${NADEKOBOT_VERSION} "
LABEL maintainer="d3lta"

ENV \
    DEBIAN_FRONTEND="noninteractive" \
    UID=99 \
    GUID=100 \
    NadekoBot__creds=/config/creds.yml \
    DOTNET_RUNNING_IN_CONTAINER=true \
    DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=false

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
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-x86_64.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-x86_64.tar.xz

ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-symlinks-noarch.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-symlinks-noarch.tar.xz
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-symlinks-arch.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-symlinks-arch.tar.xz

RUN rm -rf /tmp/*
### ### ### ### ### ###

ADD ./root/ /

# https://gitlab.com/Kwoth/nadekobot/-/releases
# https://gitlab.com/api/v4/projects/9321079/packages/generic/NadekoBot-build/5.1.10/5.1.10-linux-x64-build.tar
# https://gitlab.com/api/v4/projects/9321079/packages/generic/NadekoBot-build/5.1.10/5.1.10-linux-arm64-build.tar

ADD --chmod=644 https://gitlab.com/api/v4/projects/9321079/packages/generic/NadekoBot-build/${NADEKOBOT_VERSION}/${NADEKOBOT_VERSION}-linux-${ARCH}-build.tar /tmp

RUN \
    groupadd --gid=$UID appuser && \
    useradd -l --uid=$UID --gid=$GUID --create-home appuser && \
    mkdir -p /app && \
    tar -xvf "/tmp/${NADEKOBOT_VERSION}-linux-${ARCH}-build.tar" -C /tmp && \
    mv /tmp/nadekobot-linux-x64/** /app/ && \
    chmod 755 /etc/s6-overlay/s6-rc.d/*/run && \
    chmod 755 /etc/s6-overlay/s6-rc.d/*/up

VOLUME /config /data

ENTRYPOINT ["/init"]
