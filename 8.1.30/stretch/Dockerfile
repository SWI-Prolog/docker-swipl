FROM debian:stretch-slim
LABEL maintainer "Dave Curylo <dave@curylo.org>, Michael Hendricks <michael@ndrix.org>"
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
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
    { [ "$dpkgArch" = 'armhf' ] || [ "$dpkgArch" = 'armel' ] || apt-get install -y --no-install-recommends librocksdb4.5; } && \
    rm -rf /var/lib/apt/lists/*
RUN set -eux; \
    SWIPL_VER=8.1.30; \
    SWIPL_CHECKSUM=d37278a7818af0ffab1c972e05adbb447fc2fd3edd71fdbe74c95fe54454047b; \
    BUILD_DEPS='make cmake gcc g++ wget git autoconf libarchive-dev libgmp-dev libossp-uuid-dev libpcre3-dev libreadline-dev libedit-dev libssl-dev zlib1g-dev libdb-dev unixodbc-dev libsqlite3-dev libserd-dev libraptor2-dev libgeos++-dev libspatialindex-dev'; \
    dpkgArch="$(dpkg --print-architecture)"; \
    [ "$dpkgArch" = 'armhf' ] || [ "$dpkgArch" = 'armel' ] || BUILD_DEPS="$BUILD_DEPS librocksdb-dev"; \
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
          ..; \
    # LANG=C.UTF8 is a work-around for a 7.7.22 bug
    LANG=C.UTF8 make; \
    LANG=C.UTF8 make install; \
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
    }; \
    dpkgArch="$(dpkg --print-architecture)"; \
    install_addin space https://github.com/JanWielemaker/space.git cd6fefa63317a7a6effb61a1c5aee634ebe2ca05; \
    install_addin prosqlite https://github.com/nicos-angelopoulos/prosqlite.git 816cb2e45a5fb53290a763a3306e430b72c40794; \
    [ "$dpkgArch" = 'armhf' ] || [ "$dpkgArch" = 'armel' ] || install_addin rocksdb https://github.com/JanWielemaker/rocksdb.git 93f29d8f298d73de5719b93516acc73e00610eed; \
    [ "$dpkgArch" = 'armhf' ] || [ "$dpkgArch" = 'armel' ] ||  install_addin hdt https://github.com/JanWielemaker/hdt.git e0a0eff87fc3318434cb493690c570e1255ed30e; \
    install_addin rserve_client https://github.com/JanWielemaker/rserve_client.git befdfab843d71bdabbe9574348697a6fe5be4fc3; \
    apt-get purge -y --auto-remove $BUILD_DEPS
ENV LANG C.UTF-8
CMD ["swipl"]
