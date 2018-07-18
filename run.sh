#!/usr/bin/env bash

# Check args
if [ "$#" -eq 0 ]; then
  echo "usage: ./run.sh IMAGE_NAME [DISPLAY]"
  return 1
fi

# On Windows, DISPLAY has to be provided manually
[ -z $2 ] || DISPLAY=$2

# Get this script's path
pushd `dirname $0` > /dev/null
SCRIPTPATH=`pwd`
popd > /dev/null

set -e

# Run the container with shared X11
docker run\
  --net=host\
  -e SHELL\
  -e DISPLAY\
  -e DOCKER=1\
  -v "$HOME:$HOME:rw"\
  -v "/tmp/.X11-unix:/tmp/.X11-unix:rw"\
  --rm \
  -it $1 $SHELL
