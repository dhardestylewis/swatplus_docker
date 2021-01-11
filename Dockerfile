FROM ubuntu:latest as builder

MAINTAINER Daniel Hardesty Lewis <dhl@tacc.utexas.edu>

## TZDATA environment variables
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ America/Chicago
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV MINICONDA3_VERSION latest

RUN apt-get update && \
    apt-get install -y \
        wget \
        tar \
        cmake \
        gfortran \
        g++ \
        doxygen \
        git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

#RUN git clone https://bitbucket.org/blacklandgrasslandmodels/modular_swatplus.git /opt/swatplus && \
#RUN wget -O /opt/swatplus.tar.bz2 https://bitbucket.org/blacklandgrasslandmodels/modular_swatplus/get/master.tar.bz2 && \
RUN wget -O /opt/swatplus.tar.gz https://github.com/dhardestylewis/swatplus_predocker/archive/master.tar.gz && \
    tar -xvf /opt/swatplus.tar.gz -C /opt && \
    rm /opt/swatplus.tar.gz && \
    mv /opt/*swatplus* /opt/swatplus.d && \
#    wget -O /opt/swatplus.d/source_codes/CMakeLists.txt https://raw.githubusercontent.com/joelz575/swatplus/master/src/CMakeLists.txt && \
    rm -Rf /opt/swatplus.d/build && \
    mkdir -p /opt/swatplus.d/build
WORKDIR "/opt/swatplus.d/build"
RUN cmake ../source_codes && \
    export NPROC=$(($(grep -c ^processor /proc/cpuinfo)-1)) && \
    echo ${NPROC} && \
    echo "make -j ${NPROC}" && \
    make -j ${NPROC} && \
    echo "make -j ${NPROC} install" && \
    make -j ${NPROC} install && \
    chmod +x bin/swatplus_exe && \
    mkdir -p /opt/swatplus && \
    mv bin/swatplus_exe /opt/swatplus && \
    mv /opt/swatplus.d/data/TxtInOut_CoonCreek_aqu /opt/swatplus && \
    cp /opt/swatplus/swatplus_exe /opt/swatplus/TxtInOut_CoonCreek_aqu && \
    rm -Rf /opt/swatplus.d
WORKDIR "/"
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-${MINICONDA3_VERSION}-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    /opt/conda/bin/conda clean -tipsy && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc


FROM docker:dind
WORKDIR "/"
COPY --from=builder / .
