# Use the development LTS [16.04 xenial]
FROM ubuntu:latest

# By Rohit Goswami
LABEL maintainer="Rohit Goswami <rohit.1995@mail.ru>"
LABEL name="crDroid"

# Update apt and get build reqs
RUN apt update && apt install -y python bc bison build-essential curl flex g++-multilib gcc-multilib git gnupg gperf imagemagick lib32ncurses5-dev lib32readline-dev lib32z1-dev libesd0-dev liblz4-tool libncurses5-dev libsdl1.2-dev libssl-dev libwxgtk3.0-dev libxml2 libxml2-utils lzop pngcrush rsync schedtool squashfs-tools xsltproc zip zlib1g-dev openjdk-8-jdk ccache curl sudo git

# Download Repo
ADD https://commondatastorage.googleapis.com/git-repo-downloads/repo /usr/local/bin/
RUN chmod 755 /usr/local/bin/*

# Switch to the new user by default and make ~/ the working dir
ENV USER build
WORKDIR /home/${USER}/

# Add the build user, update password to build and add to sudo group
RUN useradd --create-home ${USER} && echo "${USER}:${USER}" | chpasswd && adduser ${USER} sudo

# Use ccache by default
ENV USE_CCACHE 1

# Use the shared volume for ccache storage
ENV CCACHE_DIR /home/build/crdroid/.ccache
RUN ccache -M 50G

# Fix permissions on home
RUN chown -R ${USER}:${USER} /home/${USER}

USER ${USER}

# Setup dummy git config
RUN git config --global user.name "${USER}" && git config --global user.email "${USER}@localhost"