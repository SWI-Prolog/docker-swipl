FROM debian:stretch-slim
LABEL maintainer "Dave Curylo <dave@curylo.org>, Michael Hendricks <michael@ndrix.org>"
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    libarchive13 \
    libgmp10 \
    libossp-uuid16 \
    libssl1.1 \
    libdb5.3 \
    libpcre3 \
    libedit2 \
    libgeos-c1v5 \
    libspatialindex4v5 \
    unixodbc \
    odbc-postgresql \
    tdsodbc \
    libmariadbclient18 && \
    rm -rf /var/lib/apt/lists/*
RUN SWIPL_VER=7.5.15 && \
    SWIPL_CHECKSUM=aca07ce9c564e608586e7ae7b9a56c82ca5dd919cde1a1edf1121efa16bda568 && \
    BUILD_DEPS='make gcc wget libarchive-dev libgmp-dev libossp-uuid-dev libpcre3-dev libreadline-dev libedit-dev libssl-dev zlib1g-dev libdb-dev libgeos-dev libspatialindex-dev unixodbc-dev' && \
    apt-get update && apt-get install -y --no-install-recommends $BUILD_DEPS && \
    mkdir /tmp/src && \
    cd /tmp/src && \
    wget http://www.swi-prolog.org/download/devel/src/swipl-$SWIPL_VER.tar.gz && \
    echo "$SWIPL_CHECKSUM  swipl-$SWIPL_VER.tar.gz" >> swipl-$SWIPL_VER.tar.gz-CHECKSUM && \
    sha256sum -c swipl-$SWIPL_VER.tar.gz-CHECKSUM && \
    tar -xzf swipl-$SWIPL_VER.tar.gz && \
    cd swipl-$SWIPL_VER && \
    cp build.templ build && \
    sed -i '/PREFIX=$HOME/c\PREFIX=/swipl' build && \
    sed -i '/# export DISABLE_PKGS/c\export DISABLE_PKGS="jpl xpce"' build && \
    sed -i '/# export EXTRA_PKGS/c\export EXTRA_PKGS="db space"' build && \
    chmod u+x build && ./build && \
    apt-get purge -y --auto-remove $BUILD_DEPS && \
    cd /usr/bin && rm -rf /tmp/src && ln -s /swipl/bin/swipl swipl && rm -rf /var/lib/apt/lists/*
ENV LANG C.UTF-8
CMD ["swipl"]
