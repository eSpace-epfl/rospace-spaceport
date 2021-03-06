# Copyright (c) 2018, Christophe Paccolat (christophe.paccolat@epfl.ch)
#
# SPDX-License-Identifier: Zlib
#
# This file is licensed under the terms of the zlib license.
# See the LICENSE.md file in the root of this repository
# for complete details. The contributors and copyright holders
# to this file maybe found in the SCM logs or in the AUTHORS.md file.

FROM osrf/ros:melodic-desktop-full-bionic

# Arguments
ARG user
ARG uid
ARG home
ARG workspace
ARG shell

# Silence deb-conf. Don't use ENV to keep defined only within the build env.
ARG DEBIAN_FRONTEND=noninteractive

# Basic Utilities
RUN apt-get -y update && \
    apt-get install -y byobu tree sudo ssh apt-utils dialog python-pip tmux

# Dependencies required to run Orekit
RUN apt-get install -y\
    openjdk-8-jre-headless

# The rest of ROS-desktop
#RUN apt-get install -y ros-lunar-desktop-full

# Additional development tools
#RUN apt-get install -y x11-apps python-pip build-essential
#RUN pip install catkin_tools

# Make SSH available
EXPOSE 22

# Clone user into docker image and set up X11 sharing
RUN \
  echo "${user}:x:${uid}:${uid}:${user},,,:${home}:${shell}" >> /etc/passwd && \
  echo "${user}:x:${uid}:" >> /etc/group && \
  echo "${user} ALL=(ALL) NOPASSWD: ALL" > "/etc/sudoers.d/${user}" && \
  chmod 0440 "/etc/sudoers.d/${user}"

RUN \
  mkdir -p /home/${user} && chown -R ${uid}:${uid} /home/${user}

# Install PyKEP
ARG CFLAGS="-march=native"
ARG CXXFLAGS="-march=native"
RUN \
    cd /root && \
    git clone -b "v2.1" https://github.com/esa/pykep.git && \
    mkdir /root/pykep/build
RUN cd /root/pykep/build && \
    cmake -DBUILD_PYKEP=ON -DBUILD_TESTS=OFF -DCMAKE_CXX_FLAGS_RELEASE=$CFLAGS \
    -DCMAKE_C_FLAGS_RELEASE=$CFLAGS .. && make -j3 && make install



# Install python deps for the local user
RUN pip install numpy sgp4 pytest pdoc matplotlib scikit-learn scipy catkin_tools mock

# Switch to user
USER "${user}"

RUN bash /opt/ros/melodic/setup.bash

# Mount the user's home directory
VOLUME "${home}"

# This is required for sharing Xauthority
ENV QT_X11_NO_MITSHM=1
ENV CATKIN_TOPLEVEL_WS="${workspace}"

# Switch to the workspace
WORKDIR ${workspace}

COPY entrypoint.sh /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
