########################################################################
# Dockerfile to build KallistiOS Toolchain + Additional Dreamcast Tools
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

# Additinal DC Tools:
#  - mksdiso Toolkit
#  - cdi4dc & mds4cd (iso converter)
#
RUN git clone --depth=1 https://github.com/Nold360/mksdiso /opt/mksdiso && \
	cd /opt/mksdiso/ && cp -r mksdiso /root/.mksdiso && \
	cp bin/burncdi bin/mksdiso /usr/local/bin/ && \
	cd src && make all && make install && cp binhack/bin/binhack32 /usr/local/bin/

RUN git clone --depth=1 https://github.com/kazade/img4dc /opt/img4dc && \
	mkdir /opt/img4dc/build && cd /opt/img4dc/build && cmake .. && make && \
	mv mds4dc/mds4dc cdi4dc/cdi4dc /usr/local/bin/

# Add user
RUN useradd -s/bin/bash -m build

# Volume to compile project sourcecode
USER build
VOLUME /src
WORKDIR /src
COPY ./run.sh /run.sh
ENTRYPOINT [ "/run.sh" ]
CMD [ "make" ]
