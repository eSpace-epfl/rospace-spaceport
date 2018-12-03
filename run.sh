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
  --net=bridge\
  -e SHELL\
  -e DISPLAY\
  -e DOCKER=1\
  -e QT_X11_NO_MITSHM=1\
  -v "$HOME:$HOME:rw"\
  -v "/tmp/.X11-unix:/tmp/.X11-unix:rw"\
  --rm \
  -it $1 $SHELL
