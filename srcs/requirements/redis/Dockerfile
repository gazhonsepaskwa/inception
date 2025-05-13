FROM debian:bullseye-slim

ARG REDIS_VERSION=8.0.0

RUN apt-get update && \
    apt-get install -y sudo && \
    sudo apt-get install -y --no-install-recommends \
        ca-certificates \
        wget \
        dpkg-dev \
        gcc \
        g++ \
        libc6-dev \
        libssl-dev \
        make \
        git \
        cmake \
        python3 \
        python3-pip \
        python3-venv \
        python3-dev \
        unzip \
        rsync \
        clang \
        automake \
        autoconf \
        libtool && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src
RUN wget -O redis-${REDIS_VERSION}.tar.gz https://github.com/redis/redis/archive/refs/tags/${REDIS_VERSION}.tar.gz && \
    tar xvf redis-${REDIS_VERSION}.tar.gz && \
    rm redis-${REDIS_VERSION}.tar.gz

WORKDIR /usr/src/redis-${REDIS_VERSION}
RUN export BUILD_TLS=yes && \
    export BUILD_WITH_MODULES=yes && \
    export INSTALL_RUST_TOOLCHAIN=yes && \
    export DISABLE_WERRORS=yes && \
    make -j "$(nproc)" all

EXPOSE 6379

CMD ["./src/redis-server", "redis-full.conf"]
