#!/usr/bin/env bash

# Copyright (c) 2018, Christophe Paccolat (christophe.paccolat@epfl.ch)
#
# SPDX-License-Identifier: Zlib
#
# This file is licensed under the terms of the zlib license.
# See the LICENSE.md file in the root of this repository
# for complete details. The contributors and copyright holders
# to this file maybe found in the SCM logs or in the AUTHORS.md file.

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
