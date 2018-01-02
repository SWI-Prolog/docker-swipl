#!/bin/sh

docker run -v `pwd`/test.pl:/src/test.pl --rm -it --entrypoint=swipl swipl -q -f /src/test.pl -g test;
