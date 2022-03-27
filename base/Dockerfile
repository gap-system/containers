FROM ubuntu:bionic

LABEL org.opencontainers.image.authors="The GAP Group <support@gap-system.org>"

ENV DEBIAN_FRONTEND noninteractive

# Prerequisites
RUN    dpkg --add-architecture i386 \
    && apt-get update -qq \
    && apt-get -qq install -y \
            autoconf \
            autogen \
            automake \
            build-essential \
            cmake \
            curl \
            g++ \
            gcc \
            gcc-multilib \
            git \
            libboost-dev \
            libcdd-dev \
            libcurl4-openssl-dev \
            libflint-dev \
            libfplll-dev \
            libglpk-dev \
            libgmp-dev \
            libgmpxx4ldbl \
            libmpc-dev \
            libmpfi-dev \
            libmpfr-dev \
            libncurses5-dev \
            libntl-dev \
            libpari-dev \
            libreadline6-dev \
            libsingular4-dev \
            libtool \
            libxml2-dev \
            libzmq3-dev \
            m4 \
            mercurial \
            pari-gp \
            polymake \
            python3-pip \
            sudo \
            unzip \
            wget \
            4ti2

RUN pip3 install notebook jupyterlab_launcher jupyterlab traitlets ipython vdom

# add gap user
RUN    adduser --quiet --shell /bin/bash --gecos "GAP user,101,," --disabled-password gap \
    && adduser gap sudo \
    && chown -R gap:gap /home/gap/ \
    && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
    && cd /home/gap \
    && touch .sudo_as_admin_successful

# Macaulay2
RUN    echo "deb http://www.math.uiuc.edu/Macaulay2/Repositories/Ubuntu $(lsb_release -sc) main" >/etc/apt/sources.list.d/macaulay2.list \
    && wget http://www2.macaulay2.com/Macaulay2/PublicKeys/Macaulay2-key \
    && apt-key add Macaulay2-key \
    && apt-get update -qq \
    && apt-get -qq install -y macaulay2

ENV LD_LIBRARY_PATH /usr/local/lib:${LD_LIBRARY_PATH}

# Set up new user and home directory in environment.
USER gap
ENV HOME /home/gap

# Note that WORKDIR will not expand environment variables in docker versions < 1.3.1.
# See docker issue 2637: https://github.com/docker/docker/issues/2637
# Start at $HOME.
WORKDIR /home/gap

# Start from a BASH shell.
CMD ["bash"]
