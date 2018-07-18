#!/usr/bin/env bash

# Check args
if [ "$#" -ne 1 ]; then
  echo "usage: ./build.sh IMAGE_NAME"
  return 1
fi

# Windows issues
#[ -z $USER ] && USER=paccolat

# Get this script's path
pushd `dirname $0` > /dev/null
SCRIPTPATH=`pwd`
popd > /dev/null

mkdir -p src && pushd src
[ -d catkin_simple ] || git clone https://github.com/catkin/catkin_simple.git
[ -d core ] || git clone git@gitlab.com:eSpace-epfl/rospace/core.git
[ -d planning ] || git clone git@gitlab.com:eSpace-epfl/rospace/planning.git
[ -d relnav ] || git clone git@gitlab.com:eSpace-epfl/rospace/relnav.git
popd

# Build the docker image
docker build\
  --build-arg user=$USER\
  --build-arg uid=$UID\
  --build-arg home=$HOME\
  --build-arg workspace=$SCRIPTPATH\
  --build-arg shell=$SHELL\
  -t $1 .
