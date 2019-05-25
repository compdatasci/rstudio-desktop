# Builds a Docker image for RStudio and Jupyter Notebook for R
#
# Authors:
# Xiangmin Jiao <xmjiao@gmail.com>

FROM x11vnc/desktop:latest
LABEL maintainer "Xiangmin Jiao <xmjiao@gmail.com>"

USER root
WORKDIR /tmp

# Install Jupyter Notebook for Python
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        python3-distutils \
        dirmngr && \
    curl -O https://bootstrap.pypa.io/get-pip.py && \
    python3 get-pip.py && \
    pip3 install -U \
         setuptools \
         ipython \
         jupyter \
         ipywidgets && \
    jupyter nbextension install --py --system \
         widgetsnbextension && \
    jupyter nbextension enable --py --system \
         widgetsnbextension && \
    pip3 install -U \
        jupyter_latex_envs==1.3.8.4 && \
    jupyter nbextension install --py --system \
        latex_envs && \
    jupyter nbextension enable --py --system \
        latex_envs && \
    jupyter nbextension install --system \
        https://bitbucket.org/ipre/calico/downloads/calico-spell-check-1.0.zip && \
    jupyter nbextension install --system \
        https://bitbucket.org/ipre/calico/downloads/calico-document-tools-1.0.zip && \
    jupyter nbextension install --system \
        https://bitbucket.org/ipre/calico/downloads/calico-cell-tools-1.0.zip && \
    jupyter nbextension enable --system \
        calico-spell-check && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install R and Rstudio
# Links of latest version of Rstudio can be found at https://www.rstudio.com/products/rstudio/download/#download
COPY install_irkernel.R /tmp/install_irkernel.R

ARG XSLT1_VERSION=1.1.28-2.1
ARG RSTUDIO_VERSION=xenial-1.1.383

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9 && \
    add-apt-repository "deb [arch=amd64,i386] https://cloud.r-project.org/bin/linux/ubuntu `lsb_release -sc`-cran35/" && \
    apt-get update && \
    apt-get upgrade -y -o Dpkg::Options::="--force-confold" && \
    apt-get install -y --no-install-recommends \
            git \
            gfortran \
            libopenblas-base \
            libatlas3-base \
            libatlas-base-dev \
            liblapack-dev \
            libxml2-dev \
            libxslt1.1 \
            libjpeg62 \
            libgstreamer1.0-0 \
            libgstreamer-plugins-base1.0-0 \
            r-base \
            libssl-dev \
            libcairo2-dev \
            libcurl4-openssl-dev && \
    R --no-save < /tmp/install_irkernel.R && \
    curl -O https://download1.rstudio.org/rstudio-$RSTUDIO_VERSION-amd64.deb && \
      dpkg -i rstudio-$RSTUDIO_VERSION-amd64.deb && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    \
    touch $DOCKER_HOME/.log/jupyter.log && \
    \
    echo '@rstudio' >> $DOCKER_HOME/.config/lxsession/LXDE/autostart && \
    chown -R $DOCKER_USER:$DOCKER_GROUP $DOCKER_HOME

WORKDIR $DOCKER_HOME
