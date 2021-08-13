########################################################################
# Dockerfile to build KallistiOS Toolchain + Additional Dreamcast Tools
########################################################################
FROM docker.io/nold360/kallistios-sdk:minimal

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
