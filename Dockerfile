# Based on prepared content
FROM ubuntu:22.04

LABEL maintainer="hhCodingCat"
ENV DEBIAN_FRONTEND=noninteractive \
    TZ=Asia/Shanghai \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

# Install required packages (no-install-recommends to reduce image size)
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential ccache cmake curl git gawk gcc-multilib g++-multilib \
    libelf-dev libfuse-dev libglib2.0-dev libgmp-dev libltdl-dev libmpc-dev libmpfr-dev \
    libncurses5-dev libncursesw5-dev python3 python3-pip python3-ply python3-docutils python3-pyelftools \
    rsync unzip wget zlib1g-dev squashfs-tools device-tree-compiler zstd \
    binutils bison flex gettext p7zip-full patch pkgconf ninja-build \
    texinfo make file ca-certificates tzdata gnupg less vim locales locales-all \
    apt-transport-https \
    gh \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create non-root user "builder" for running builds inside container
RUN useradd -m -s /bin/bash builder \
    && mkdir -p /workdir /home/builder/.ccache /opt/cache \
    && chown -R builder:builder /workdir /home/builder /opt/cache

USER builder
WORKDIR /workdir

ENV CCACHE_DIR=/home/builder/.ccache
ENV PATH=/usr/lib/ccache:${PATH}
ENV HOME=/home/builder

RUN mkdir -p /workdir/openwrt

LABEL org.opencontainers.image.title="imwrt-builder" \
      org.opencontainers.image.description="Prebuilt builder image for ImmortalWrt/OpenWrt (includes ccache, build deps)" \
      org.opencontainers.image.vendor="hhCodingCat"

CMD ["/bin/bash"]