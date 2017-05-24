FROM debian:jessie
LABEL maintainer "Dave Curylo <dave@curylo.org>, Michael Hendricks <michael@ndrix.org>"
RUN SWIPL_VER=7.5.6 && \
    SWIPL_CHECKSUM=47c31d4d3140e96706295555b01916dd7bde6c4151c80515a48e7aabfc747288 && \
    apt-get update && \
    apt-get dist-upgrade -y && \
    apt-get install -y build-essential curl libarchive13 libarchive-dev libgmp-dev libossp-uuid-dev libpcre3-dev libreadline-dev libedit-dev libssl-dev zlib1g-dev libdb-dev libgeos++-dev libspatialindex-dev unixodbc-dev && \
    mkdir /tmp/src && \
    cd /tmp/src && \
    curl -O http://www.swi-prolog.org/download/devel/src/swipl-$SWIPL_VER.tar.gz && \
    echo "$SWIPL_CHECKSUM  swipl-$SWIPL_VER.tar.gz" >> swipl-$SWIPL_VER.tar.gz-CHECKSUM && \
    sha256sum -c swipl-$SWIPL_VER.tar.gz-CHECKSUM && \
    tar -xzf swipl-$SWIPL_VER.tar.gz && \
    cd swipl-$SWIPL_VER && \
    curl -O https://raw.githubusercontent.com/SWI-Prolog/docker-swipl/master/build && \
    chmod u+x build && ./build && \
    apt-get purge -y build-essential libarchive-dev libgmp-dev libossp-uuid-dev libpcre3-dev libreadline-dev libedit-dev libssl-dev zlib1g-dev libdb-dev libgeos++-dev libspatialindex-dev unixodbc-dev && \
    apt-get autoremove -y && \
    apt-get install -y libarchive13 libgmp10 libossp-uuid16 libssl1.0.0 libdb5.3 libpcre3 libedit2 libgeos++ libspatialindex3 unixodbc odbc-postgresql tdsodbc libmyodbc && \
    apt-get clean -y && \
    cd /usr/bin && rm -rf /tmp/src && ln -s /swipl/bin/swipl swipl
CMD ["swipl"]