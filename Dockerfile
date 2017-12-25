# Use the Phusion [Ubuntu 16.04 LTS]
FROM phusion/baseimage:latest

# Use baseimage-docker's init system [Phusion]
CMD ["/sbin/my_init"]

# Phusion SSH special
RUN /usr/sbin/enable_insecure_key

# By Rohit Goswami
LABEL maintainer="Rohit Goswami <rohit.1995@mail.ru>"
LABEL name="crDroid"

# Update apt and get build reqs [from https://forum.xda-developers.com/chef-central/android/how-to-build-lineageos-14-1-t3551484]
RUN apt update && apt install -y bc bison build-essential curl flex g++-multilib gcc-multilib git gnupg \
 gperf imagemagick lib32ncurses5-dev lib32readline6-dev lib32z1-dev libesd0-dev liblz4-tool \
 libncurses5-dev libsdl1.2-dev libwxgtk3.0-dev libxml2 libxml2-utils lzop pngcrush schedtool \
 squashfs-tools xsltproc zip zlib1g-dev \
 python openjdk-8-jdk ccache sudo 

# Clean up APT when done. [Phusion]
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

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

# Fix for Jack
ENV JACK_SERVER_VM_ARGUMENTS="-Dfile.encoding=UTF-8 -XX:+TieredCompilation -Xmx4096m"

# Use the shared volume for ccache storage
ENV CCACHE_DIR /home/build/crdroid/.ccache
RUN ccache -M 50G

# Fix permissions on home
RUN chown -R ${USER}:${USER} /home/${USER}

USER ${USER}

# Setup dummy git config
RUN git config --global user.name "${USER}" && git config --global user.email "${USER}@localhost"
