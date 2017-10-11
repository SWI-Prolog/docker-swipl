FROM debian:stretch-slim as base
LABEL maintainer "Dave Curylo <dave@curylo.org>, Michael Hendricks <michael@ndrix.org>"

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    libarchive13 \
    libgmp10 \
    libossp-uuid16 \
    libssl1.1 \
    ca-certificates \
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

FROM base as build

ENV SWIPL_VER 7.7.1
ENV SWIPL_CHECKSUM fda2c8b6b606ff199ea8a6f019008aa8272b7c349cb9312ccd5944153509503a
ENV BUILD_DEPS make gcc g++ wget libarchive-dev libgmp-dev libossp-uuid-dev libpcre3-dev \
	       libreadline-dev libedit-dev libssl-dev zlib1g-dev libdb-dev libgeos++-dev \
	       libspatialindex-dev unixodbc-dev git autoconf

ENV SPACE_SHA1 cd6fefa63317a7a6effb61a1c5aee634ebe2ca05

RUN apt-get update && apt-get install -y --no-install-recommends ${BUILD_DEPS}
RUN mkdir /tmp/src && \
    cd /tmp/src && \
    wget http://www.swi-prolog.org/download/devel/src/swipl-${SWIPL_VER}.tar.gz && \
    echo "${SWIPL_CHECKSUM}  swipl-${SWIPL_VER}.tar.gz" >> swipl-${SWIPL_VER}.tar.gz-CHECKSUM && \
    sha256sum -c swipl-${SWIPL_VER}.tar.gz-CHECKSUM && \
    tar -xzf swipl-${SWIPL_VER}.tar.gz && \
    cd swipl-${SWIPL_VER} && \
    cp build.templ build && \
    sed -i '/PREFIX=$HOME/c\PREFIX=/swipl' build && \
    sed -i '/# export DISABLE_PKGS/c\export DISABLE_PKGS="jpl xpce"' build && \
    sed -i 's/# *\(.*--disable-libdirversion\)/\1/' build && \
    chmod u+x build && ./build && \
    rm -r /tmp/src && \
    cd /usr/bin && ln -s /swipl/bin/swipl swipl

RUN mkdir /swipl/lib/swipl/pack && \
    cd /swipl/lib/swipl/pack && \
    git clone https://github.com/JanWielemaker/space.git && \
    (cd space && git checkout -q ${SPACE_SHA1}) && \
    (cd space && ln -s configure.ac configure.in) && \
    swipl -g 'pack_rebuild(space)' -t halt

FROM base

COPY --from=build /swipl /swipl
RUN cd /usr/bin && ln -s /swipl/bin/swipl* .

ENV LANG C.UTF-8
CMD ["swipl"]
