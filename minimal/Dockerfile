########################################################################
# Dockerfile to build minimal KallistiOS Toolchain
########################################################################
FROM debian:jessie

ENV DEBIAN_FRONTEND noninteractive

# Prerequirements / second line for libs / third line for mksdiso & img4dc
RUN apt-get update && apt-get -y install build-essential git curl texinfo python subversion \
	libjpeg-dev libpng++-dev \
	genisoimage p7zip-full cmake && \
	apt-get clean

# Fetch sources
RUN mkdir -p /opt/toolchains/dc && \
	git clone --depth=1 https://github.com/Nold360/KallistiOS    /opt/toolchains/dc/kos && \
	git clone --depth=1 https://github.com/KallistiOS/kos-ports  /opt/toolchains/dc/kos-ports

# Setup KOS Environment
RUN cp /opt/toolchains/dc/kos/doc/environ.sh.sample /opt/toolchains/dc/kos/environ.sh && \
	echo 'source /opt/toolchains/dc/kos/environ.sh' >> /root/.bashrc

# Build Toolchain
WORKDIR /opt/toolchains/dc/kos/utils/dc-chain
RUN bash download.sh && \
	bash unpack.sh && \
	make erase=1 && \
	bash cleanup.sh

WORKDIR /opt/toolchains/dc/kos/utils/kmgenc 
RUN bash -c 'source /opt/toolchains/dc/kos/environ.sh ; make'

# Build KOS-/Ports
WORKDIR /opt/toolchains/dc/kos
RUN bash -c 'source /opt/toolchains/dc/kos/environ.sh ; make && make kos-ports_all'

# Volume to compile project sourcecode
VOLUME /src
WORKDIR /src
COPY ./run.sh /run.sh
ENTRYPOINT [ "/run.sh" ]
CMD [ "make" ]
