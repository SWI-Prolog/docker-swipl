FROM alpine
LABEL maintainer "Dave Curylo <dave@curylo.org>, Michael Hendricks <michael@ndrix.org>"
RUN SWIPL_VER=7.5.7 && \
    SWIPL_CHECKSUM=648d15a534a3503ef281cc7c2ead7ee913866c3d7cb1d1344508ee24b96b4512 \
    && apk --update add --no-cache curl libarchive readline pcre gmp libressl libedit zlib db unixodbc libuuid \
    && apk --update add --no-cache --virtual build-dependencies bash alpine-sdk autoconf libarchive-dev gmp-dev pcre-dev readline-dev libedit-dev libressl-dev zlib-dev db-dev unixodbc-dev util-linux-dev linux-headers \
    && apk add geos-dev --update-cache --virtual build-dependencies --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted \
    && curl -O http://www.swi-prolog.org/download/devel/src/swipl-$SWIPL_VER.tar.gz \
    && echo "$SWIPL_CHECKSUM  swipl-$SWIPL_VER.tar.gz" >> swipl-$SWIPL_VER.tar.gz-CHECKSUM \
    && sha256sum -c swipl-$SWIPL_VER.tar.gz-CHECKSUM \
    && tar -xzf swipl-$SWIPL_VER.tar.gz \
    && cd swipl-$SWIPL_VER && ./configure && make && make install \
    && cd packages && ./configure && make && make install \
    && apk del build-dependencies \
    && cd ../.. && rm -rf swipl-$SWIPL_VER.tar.gz swipl-$SWIPL_VER.tar.gz-CHECKSUM swipl-$SWIPL_VER
CMD ["swipl"]