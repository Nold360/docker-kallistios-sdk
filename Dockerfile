############################################################
# Dockerfile to build KallistiOS Toolchain for Dreamcast
############################################################
FROM debian:jessie

ENV DEBIAN_FRONTEND noninteractive

# Prerequirements / second line for libs / third line for mksdiso-package
RUN apt-get update && apt-get -y install build-essential git curl texinfo python subversion \
	libjpeg-dev libpng++-dev \
	genisoimage p7zip && \
	apt-get clean

# Fetch sources
RUN mkdir -p /opt/toolchains/dc && \
	git clone --depth=1 https://github.com/KallistiOS/KallistiOS /opt/toolchains/dc/kos && \
	git clone --depth=1 https://github.com/KallistiOS/kos-ports  /opt/toolchains/dc/kos-ports

# Setup KOS Environment
RUN cp /opt/toolchains/dc/kos/doc/environ.sh.sample /opt/toolchains/dc/kos/environ.sh && \
	echo 'source /opt/toolchains/dc/kos/environ.sh' >> /root/.bashrc

# Build Toolchain
RUN cd /opt/toolchains/dc/kos/utils/dc-chain && \
	bash download.sh && \
	bash unpack.sh && \
	make erase=1 && \
	bash cleanup.sh

# Build KOS-/Ports
RUN cd /opt/toolchains/dc/kos && bash -c 'source /opt/toolchains/dc/kos/environ.sh; make ; make kos-ports_all'

# Add mksdiso-pack for additinal DC tools
# FIXME: No compilation ATM, just x86 binaries & some scripts
RUN git clone --depth=1 https://github.com/Nold360/mksdiso /opt/mksdiso && \
	cd /opt/mksdiso && make install

# Volume to compile project sourcecode
VOLUME /src
WORKDIR /src
COPY ./run.sh /run.sh
ENTRYPOINT [ "/run.sh" ]
CMD [ "make" ]
