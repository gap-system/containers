FROM ghcr.io/gap-system/gap-docker-base:master

ARG BRANCH

MAINTAINER The GAP Group <support@gap-system.org>

# download and build GAP
RUN    mkdir /home/gap/inst/ \
    && cd /home/gap/inst/ \
    && git clone --depth=1 -b ${BRANCH} https://github.com/gap-system/gap gap-${BRANCH} \
    && cd gap-${BRANCH} \
    && ./autogen.sh \
    && ./configure \
    && make \
    && cp bin/gap.sh bin/gap

# download and build GAP packages
RUN    mkdir /home/gap/inst/gap-${BRANCH}/pkg \
    && cd /home/gap/inst/gap-${BRANCH}/pkg \
    && wget -q https://files.gap-system.org/gap4pkgs/packages-${BRANCH}.tar.gz \
    && tar xzf packages-${BRANCH}.tar.gz \
    && ../bin/BuildPackages.sh

# build JupyterKernel
RUN    cd /home/gap/inst/gap-${BRANCH}/pkg \
    && mv JupyterKernel-* JupyterKernel \
    && cd JupyterKernel \
    && pip3 install . --user

RUN jupyter serverextension enable --py jupyterlab --user

ENV PATH /home/gap/inst/gap-${BRANCH}/pkg/JupyterKernel/bin:${PATH}
ENV JUPYTER_GAP_EXECUTABLE /home/gap/inst/gap-${BRANCH}/bin/gap.sh

ENV GAP_HOME /home/gap/inst/gap-${BRANCH}
ENV PATH ${GAP_HOME}/bin:${PATH}
