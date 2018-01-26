########################################################################
# Dockerfile to build KallistiOS + DreamShell SDK
########################################################################
FROM nold360/kallistios-sdk:latest

RUN git clone --depth=1 https://github.com/nold360/DreamShell /opt/toolchains/dc/kos/ds

# Download & Unpack Toolchain
WORKDIR /opt/toolchains/dc/kos/ds/sdk/toolchain
RUN bash download.sh && \
	bash unpack.sh && \
	rm *.gz *.bz2

# Build Toolchain
RUN bash -c 'source /opt/toolchains/dc/kos/environ.sh; make makejobs=-j2 verbose=1 erase=1'

# Build DS-Libs
WORKDIR /opt/toolchains/dc/kos/ds/lib
RUN bash -c 'source /opt/toolchains/dc/kos/environ.sh; make'

# Rebuild patched KOS
WORKDIR /opt/toolchains/dc/kos
RUN bash -c 'source /opt/toolchains/dc/kos/environ.sh; make'

# Test-Build Dreamshell
WORKDIR /opt/toolchains/dc/kos/ds
RUN bash -c 'source /opt/toolchains/dc/kos/environ.sh; make && make clean'

WORKDIR /src
