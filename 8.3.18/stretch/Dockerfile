FROM debian:stretch-slim
LABEL maintainer "Dave Curylo <dave@curylo.org>, Michael Hendricks <michael@ndrix.org>"
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    libtcmalloc-minimal4 \
    libarchive13 \
    libyaml-dev \
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
    libmariadbclient18 \
    libsqlite3-0 \
    libserd-0-0 \
    libraptor2-0 && \
    dpkgArch="$(dpkg --print-architecture)" && \
    rm -rf /var/lib/apt/lists/*
ENV LANG C.UTF-8
RUN set -eux; \
    SWIPL_VER=8.3.18; \
    SWIPL_CHECKSUM=528349b353b36dde3d57d1de366a45e4fbbb89d4a96de907b9a0497e601be768; \
    BUILD_DEPS='make cmake ninja-build gcc g++ wget git autoconf libarchive-dev libgmp-dev libossp-uuid-dev libpcre3-dev libreadline-dev libedit-dev libssl-dev zlib1g-dev libdb-dev unixodbc-dev libsqlite3-dev libserd-dev libraptor2-dev libgeos++-dev libspatialindex-dev libgoogle-perftools-dev'; \
    dpkgArch="$(dpkg --print-architecture)"; \
    apt-get update; apt-get install -y --no-install-recommends $BUILD_DEPS; rm -rf /var/lib/apt/lists/*; \
    mkdir /tmp/src; \
    cd /tmp/src; \
    wget -q https://www.swi-prolog.org/download/devel/src/swipl-$SWIPL_VER.tar.gz; \
    echo "$SWIPL_CHECKSUM  swipl-$SWIPL_VER.tar.gz" >> swipl-$SWIPL_VER.tar.gz-CHECKSUM; \
    sha256sum -c swipl-$SWIPL_VER.tar.gz-CHECKSUM; \
    tar -xzf swipl-$SWIPL_VER.tar.gz; \
    mkdir swipl-$SWIPL_VER/build; \
    cd swipl-$SWIPL_VER/build; \
    cmake -DCMAKE_BUILD_TYPE=Release \
          -DSWIPL_PACKAGES_X=OFF \
	  -DSWIPL_PACKAGES_JAVA=OFF \
	  -DCMAKE_INSTALL_PREFIX=/usr \
	  -G Ninja \
          ..; \
    ../scripts/pgo-compile.sh; \
    ninja; \
    ninja install; \
    rm -rf /tmp/src; \
    mkdir -p /usr/share/swi-prolog/pack; \
    cd /usr/share/swi-prolog/pack; \
    # usage: install_addin addin-name git-url git-commit
    install_addin () { \
        git clone "$2" "$1"; \
        git -C "$1" checkout -q "$3"; \
        # the prosqlite plugin lib directory must be removed?
        if [ "$1" = 'prosqlite' ]; then rm -rf "$1/lib"; fi; \
        swipl -g "pack_rebuild($1)" -t halt; \
        find "$1" -mindepth 1 -maxdepth 1 ! -name lib ! -name prolog ! -name pack.pl -exec rm -rf {} +; \
        find "$1" -name .git -exec rm -rf {} +; \
        find "$1" -name '*.so' -exec strip {} +; \
    }; \
    dpkgArch="$(dpkg --print-architecture)"; \
    install_addin space https://github.com/JanWielemaker/space.git cd6fefa63317a7a6effb61a1c5aee634ebe2ca05; \
    install_addin prosqlite https://github.com/nicos-angelopoulos/prosqlite.git cfd2f68709f5fb61833c0e2f8e9c6546e542009c; \
    [ "$dpkgArch" = 'armhf' ] || [ "$dpkgArch" = 'armel' ] || install_addin rocksdb https://github.com/JanWielemaker/rocksdb.git f110766ee97cfbc6fddd4c33b7238f00e76ecc18; \
    [ "$dpkgArch" = 'armhf' ] || [ "$dpkgArch" = 'armel' ] ||  install_addin hdt https://github.com/JanWielemaker/hdt.git e0a0eff87fc3318434cb493690c570e1255ed30e; \
    install_addin rserve_client https://github.com/JanWielemaker/rserve_client.git f8e83a4e1e4600baef4222dc4c2904a41a79a5ad; \
    apt-get purge -y --auto-remove $BUILD_DEPS
CMD ["swipl"]
