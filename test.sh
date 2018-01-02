#!/bin/sh

ALL_ARCH="[library(space/space)], [library(prosqlite)], [library(r/r_call)]."

AMD_ARCH="[library(rocksdb)], [library(hdt)]."

ARCHITECTURE=`lscpu | grep Architecture | awk '{print $2}'`

echo "Testing loading of multi-architecture modules."
echo "test:-$ALL_ARCH" > test.pl;
docker run -v `pwd`/test.pl:/src/test.pl --rm -it --entrypoint=swipl swipl -q -f /src/test.pl -t test;
rm test.pl
echo "Multi-architecture modules loaded successfully."

if [ "$ARCHITECTURE" == 'x86_64' ]; then
    echo "Testing loading of AMD64 architecture modules."
    echo "test:-$AMD_ARCH" > test.pl;
    docker run -v `pwd`/test.pl:/src/test.pl --rm -it --entrypoint=swipl swipl -q -f /src/test.pl -t test;
    rm test.pl
    echo "AMD64 architecture modules loaded successfully."
fi
