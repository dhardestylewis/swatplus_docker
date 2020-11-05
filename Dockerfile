FROM ubuntu:latest

MAINTAINER Daniel Hardesty Lewis <dhl@tacc.utexas.edu>

## TZDATA environment variables
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ America/Chicago
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
#ENV NPROC $(($(grep -c ^processor /proc/cpuinfo)-1))

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
RUN wget -O /opt/swatplus.tar.bz2 https://bitbucket.org/blacklandgrasslandmodels/modular_swatplus/get/master.tar.bz2 && \
    tar -xvf /opt/swatplus.tar.bz2 -C /opt && \
    rm /opt/swatplus.tar.bz2 && \
    mv /opt/*swatplus* /opt/swatplus.git && \
    wget -O /opt/swatplus.git/source_codes/CMakeLists.txt https://raw.githubusercontent.com/joelz575/swatplus/master/src/CMakeLists.txt && \
    mkdir /opt/swatplus.git/build
WORKDIR "/opt/swatplus.git/build"
RUN cmake ../source_codes && \
    make -j ${NPROC} && \
    make -j ${NPROC} install && \
    chmod +x swatplus_exe && \
    mkdir /opt/swatplus && \
    mv swatplus_exe /opt/swatplus && \
    mv /opt/swatplus.git/data/TxtInOut_CoonCreek_aqu /opt/swatplus && \
    cp /opt/swatplus/swatplus_exe /opt/swatplus/TxtInOut_CoonCreek_aqu
    rm -Rf /opt/swatplus.git
WORKDIR "/"

