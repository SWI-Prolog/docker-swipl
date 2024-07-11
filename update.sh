#!/bin/bash

series=devel

confirm()
{ while true; do
    echo -n "$1 "
    read answer
    case "$answer" in
          y*)   return 0
                ;;
          n*)   return 1
                ;;
          *)
                echo "Please answer yes or no"
                ;;
    esac
  done
}

usage()
{ cat <<EOF
Usage: $prog [option..]

Options
  --stable		Create Docker for stable series
  --from=version	Create from base <version>
EOF
}

test()
{ img="$1"

  echo "### Testing $img"
  got=$(docker run -it --rm $img swipl --version)
  if echo $got | fgrep -q $VERSION; then
      echo "Found correct version"
  else
      echo "ERROR: Got $got, expected version $VERSION"
      return 1
  fi

  if docker run -it --rm $img swipl -g check_installation -t halt | grep -q "Found 2 issues"; then
      echo "Check installation passed"
  else
      echo "ERROR: Check installation failed"
      return 1
  fi
}

done=false
while [ $done = false ]; do
    case "$1" in
        --help)
	    usage
	    exit 0
	    ;;
	--stable)
	    series=stable
	    shift
	    ;;
	--from=*)
	    from=$(echo $1 | sed 's/^--[a-z]*=//')
	    shift
	    ;;
	--*)
	    usage
	    exit 1
	    ;;
	*)
	    done=true
	    ;;
    esac
done

VERSION=$(curl -s https://www.swi-prolog.org/download/$series/src/swipl-latest.tar.gz | \
	      grep '"location"' | sed 's/.*swipl-\(.*\)\.tar.*/\1/')

if [ -z "$from" ]; then
    if [ $series == devel ]; then
	from=$(ls -td [0-9].[13579]* | head -1)
    else
	from=$(ls -td [0-9].[02468]* | head -1)
    fi
fi

if ! confirm "Create Dockerfile for $VERSION from $from?"; then
    exit 1
fi

cp -r $from $VERSION
hash=$(curl -s https://www.swi-prolog.org/download/$series/src/swipl-$VERSION.tar.gz.sha256)
echo "SHA256=$hash"

dockerfiles=
for base in bookworm bullseye; do
  sed -i -e "s/$from/$VERSION/" \
         -e "s/SWIPL_CHECKSUM=[a-f0-9]*/SWIPL_CHECKSUM=$hash/" \
	 $VERSION/$base/Dockerfile
  docker pull debian:$base
  (cd $VERSION/$base && \
       docker build -t swipl-$VERSION:$base . 2>&1 > build.log)
  test swipl-$VERSION:$base || exit 1
  dockerfiles+=" $VERSION/$base/Dockerfile"
done

if confirm "Commit $dockerfiles?"; then
    git add $dockerfiles 
    git commit -m "Update to $VERSION $series version"
fi
