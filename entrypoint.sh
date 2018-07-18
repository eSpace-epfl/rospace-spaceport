#!/usr/bin/env bash

echo $@
env
cd ${CATKIN_TOPLEVEL_WS}
mkdir -p src && cd src
export ROS_LANG_DISABLE="genlisp:geneus:gennodejs"
source /opt/ros/melodic/setup.bash

if [ ! -f CMakeLists.txt ]; then catkin_init_workspace; else echo "CMakeList file already there";fi
if [ ! -f .rosinstall ]; then wstool init; else echo "rosinstall file already there";fi
wstool up

cd ..
catkin_make clean
catkin_make
source ${CATKIN_TOPLEVEL_WS}/devel/setup.bash
echo 'Running: ' $@
exec "$@"
