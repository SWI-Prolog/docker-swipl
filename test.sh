#!/bin/sh

img=${IMG:-swipl}

docker run -v `pwd`/test.pl:/src/test.pl --rm -it --entrypoint=swipl $img --on-error=status /src/test.pl
