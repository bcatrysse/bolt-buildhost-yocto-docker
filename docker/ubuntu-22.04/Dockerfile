# DOCKERFILE : Dockerfile  for yocto-ubuntu-22
# WHAT       : Is a Dockerfile allowing to build a docker containter 
#              that represents yocto build host for building bolt images in context of RDK Firebolt 
#              host is based on a specific Ubuntu LTS version
# PURPOSE :    To have representative build environment for developers              
#----------------------------------------------------------------------
# Flint Weller
# 20220520 Original
# 20220804 Changed name and directory location
# 20251105 Bart Catrysse update
# ----------------------------------------------------------------------
# INSTRUCTIONS
#
# Create Docker image from this dockerfile with command:
# $ docker build --no-cache \
#     --file ${HOME}/Tools/dockerfiles/Dockerfile-yocto-ubuntu-22
#     --tag yocto-ubuntu-22:latest .
#
# Deploy a container with the working directory mounted
# SYNTAX   :
# $ docker run -it -P --hostname HostName --name DockerContainerName \
#     -v WorkstationDirectory:DockerDirectory DockerImageName
# EXAMPLE  :
# $ docker run -it -P --hostname yocto-ubuntu-22 --name imx8-kirkstone \
#     -v /work/docker/kirkstone:/home/build yocto-kirkstone-ubuntu-20
# EXAMPLE docker run script :
##!/bin/bash
#set -x
#
#docker run -it --rm \
#     --init \
#     --network=host \
#     --hostname="yocto-ubuntu-22" \
#     --add-host yocto-ubuntu-22:127.0.0.1 \
#     --volume ${HOME}:${HOME} \
#     --user $UID:$GID \
#     --group-add 10 \
#     --volume="/etc/group:/etc/group:ro" \
#     --volume="/etc/passwd:/etc/passwd:ro" \
#     --volume="/etc/shadow:/etc/shadow:ro" \
#       yocto-ubuntu-22.04:latest
#
# # adding user to group_id 10 which is "wheel" group
# # because "wheel" group members have sudo rights in container image via /etc/sudoers.d/99_wheel

# ----------------------------------------------------------------------
# Ubuntu LTS release version numbers with code names
# Ubuntu 22.04 LTS = Jammy Jellyfish
# Ubuntu 20.04 LTS = Focal Fossa
# ----------------------------------------------------------------------

# ----------------------------------------------------------------------
# FROM must be the first command in a dockerfile
# Specify Ubuntu base image digest to pull from, taking here version 22.04 
#
FROM ubuntu:22.04

LABEL org.opencontainers.image.title="Yocto Build Host based on Ubuntu 22.04"
LABEL org.opencontainers.image.source="https://github.com/bcatrysse/bolt-buildhost-yocto-docker"

# ----------------------------------------------------------------------
# Use DEBIAN_FRONTEND=noninteractive to avoid image build hang waiting
# for a default confirmation [Y/n] at some configurations.
# ADDING shell command to ensure we catch errors and build does not fail silently 
ENV DEBIAN_FRONTEND=noninteractive
SHELL ["/bin/bash", "-euo", "pipefail", "-c"]

# ----------------------------------------------------------------------
# Base image update and upgrade Install dependencies
RUN apt-get update && apt-get upgrade -y


# ----------------------------------------------------------------------
# set timezone in container to UTC
RUN ln -fs /usr/share/zoneinfo/Universal /etc/localtime \
# RUN DEBIAN_FRONTEND=noninteractive 
&& apt-get install -y --no-install-recommends tzdata


# ------------------------------
# Enable i386 multilib and install toolchains *atomically*
#  - Add i386 arch first
#  - Refresh indices
#  - Install multilib and 32-bit dev runtime
#  - Clean apt caches in the same layer
 RUN dpkg --add-architecture i386 \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
         g++-multilib gcc-multilib \
  && rm -rf /var/lib/apt/lists/*

# ----------------------------------------------------------------------
# Put everything we want to install here
# keep in a separate layer so failures are visible and don’t mask multilib
# remove line RUN DEBIAN_FRONTEND=noninteractive apt install \
#  -y --no-install-recommends --fix-missing \
RUN apt-get update \
 && apt-get install -y --no-install-recommends --fix-missing \
  ant apt-utils bash-completion build-essential ca-certificates chrpath cmake cpio \
  gnupg dirmngr libacl1 \
  curl debianutils diffstat fd-find file g++ gawk gcc git \
  git-flow git-man iputils-ping jq less libbz2-dev libegl1-mesa libffi-dev \
  libglib2.0-dev libldap2-dev liblz4-tool liblzma-dev libncurses5-dev \
  libreadline-dev libsasl2-dev libsdl1.2-dev libslang2-dev libsqlite3-dev \
  libssl-dev libxml2-dev libxmlsec1-dev llvm locales make mesa-common-dev \
  net-tools nnn openssh-client pylint python3 python3-git \
  python3-jinja2 python3-pexpect python3-pip python3-subunit ripgrep \
  rsync screen socat sudo sysstat tar texinfo tk-dev tree unzip vim \
  wget xterm xz-utils zip zlib1g-dev zstd 
# Notes
#   git-core is a dummy package that calls git
#   zstd provides pzstd
#   liblz4-tool provides lz4c and lz4


# ----------------------------------------------------------------------
# remove cached package files to save space 
RUN apt-get clean \
& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# ----------------------------------------------------------------------
# Set up locales
RUN locale-gen en_US.UTF-8 \
  && update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8


# ----------------------------------------------------------------------
# Yocto requires the source command for setting up the build environment, so
# Replace dash with bash (Ubuntu uses dash as /bin/sh for system shells)
# https://wiki.ubuntu.com/DashAsBinSh
# Note that using && below to chain commands is essential to avoid failure
RUN rm /bin/sh && ln -s bash /bin/sh


# ----------------------------------------------------------------------
# Install the google repo utility
# disavantage of not using apt-get install repo is that deps might not be installed, added gnupng dirmngr in apt-get install list above to manually solve
RUN curl -o /usr/local/bin/repo https://storage.googleapis.com/git-repo-downloads/repo 
RUN chmod a+x /usr/local/bin/repo



# ----------------------------------------------------------------------
# Do additional setup
RUN ln -s /usr/bin/python3 /usr/bin/python

# add "wheel" group (from local) for sudo
#RUN groupadd -g 10 wheel
COPY rootfs/99_wheel /etc/sudoers.d/99_wheel



# ----------------------------------------------------------------------
# Install the additional tools
#RUN DEBIAN_FRONTEND=noninteractive apt install \
#  -y --no-install-recommends --fix-missing \
#qemu-arm
