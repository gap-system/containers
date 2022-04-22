FROM ubuntu:21.10 AS base

LABEL maintainer="The GAP Group <support@gap-system.org>"

ENV DEBIAN_FRONTEND noninteractive

# Prerequisites
RUN    apt-get update -qq \
    && apt-get -qq install -y \
            autoconf \
            autogen \
            automake \
            build-essential \
            cmake \
            curl \
            g++ \
            gcc \
            git \
            libgmp-dev \
            libreadline6-dev \
            libtool \
            m4 \
            sudo \
            unzip \
            wget

 #add gap user
RUN    adduser --quiet --shell /bin/bash --gecos "GAP user,101,," --disabled-password gap \
    && adduser gap sudo \
    && chown -R gap:gap /home/gap/ \
    && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
    && cd /home/gap \
    && touch .sudo_as_admin_successful

ENV LD_LIBRARY_PATH /usr/local/lib:${LD_LIBRARY_PATH}

# Set up new user and home directory in environment.
#USER gap
ENV HOME /home/gap

# Note that WORKDIR will not expand environment variables in docker versions < 1.3.1.
# See docker issue 2637: https://github.com/docker/docker/issues/2637
# Start at $HOME.
WORKDIR /home/gap

# Start from a BASH shell.
CMD ["bash"]


##########################################################################################
# all-deps has all packages installed that are needed to compile all GAP packages
FROM base AS all-deps

LABEL maintainer="The GAP Group <support@gap-system.org>"

ENV DEBIAN_FRONTEND noninteractive

#USER root
ENV HOME /home/root

# Prerequisites
RUN    apt-get -qq install -y \
        gcc-multilib \
        libcdd-dev \
        libcurl4-openssl-dev \
        libflint-dev \
        libglpk-dev \
        libgmpxx4ldbl \
        libmpc-dev \
        libmpfi-dev \
        libmpfr-dev \
        libncurses5-dev \
        libntl-dev \
        libxml2-dev \
        libzmq3-dev \
        libx11-dev \
        libxaw7-dev \
        libxt-dev

#USER gap
ENV HOME /home/gap


##########################################################################################

FROM base AS gap-minimal

LABEL maintainer="The GAP Group <support@gap-system.org>"

ARG GAP_VERSION

ENV DEBIAN_FRONTEND noninteractive

ADD ./prepare_gap.sh .
RUN ./prepare_gap.sh -v ${GAP_VERSION} -d 0 -t minimal \
    && rm prepare_gap.sh

ENV GAP_HOME /home/gap/inst/gap-${GAP_VERSION}
ENV PATH ${GAP_HOME}/bin:${PATH}


##########################################################################################

FROM all-deps AS gap-full

LABEL maintainer="The GAP Group <support@gap-system.org>"

ARG GAP_VERSION

ENV DEBIAN_FRONTEND noninteractive

ADD ./prepare_gap.sh .
RUN ./prepare_gap.sh -v ${GAP_VERSION} -d 0 -t full \
    && rm prepare_gap.sh

ENV GAP_HOME /home/gap/inst/gap-${GAP_VERSION}
ENV PATH ${GAP_HOME}/bin:${PATH}


##########################################################################################

FROM base AS gap-minimal-debug

LABEL maintainer="The GAP Group <support@gap-system.org>"

ARG GAP_VERSION

ENV DEBIAN_FRONTEND noninteractive

ADD ./prepare_gap.sh .
RUN ./prepare_gap.sh -v ${GAP_VERSION} -d 1 -t minimal \
    && rm prepare_gap.sh

ENV GAP_HOME /home/gap/inst/gap-${GAP_VERSION}
ENV PATH ${GAP_HOME}/bin:${PATH}


##########################################################################################

FROM all-deps AS gap-full-debug

LABEL maintainer="The GAP Group <support@gap-system.org>"

ARG GAP_VERSION

ENV DEBIAN_FRONTEND noninteractive

ADD ./prepare_gap.sh .
RUN ./prepare_gap.sh -v ${GAP_VERSION} -d 1 -t full \
    && rm prepare_gap.sh

ENV GAP_HOME /home/gap/inst/gap-${GAP_VERSION}
ENV PATH ${GAP_HOME}/bin:${PATH}