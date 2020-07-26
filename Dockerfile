FROM debian:stable-slim

MAINTAINER Paolo Frizzera <geofrizz@gmail.com>

RUN apt-get update && apt-get upgrade -y
RUN apt-get update && apt-get install -y \
	apt-utils git wget g++ cmake cmake-curses-gui make autoconf automake libtool unzip curl \
	gobjc++ libclang-dev gawk libc++-dev libzthread-dev libblis-pthread-dev

RUN apt-get install -y \
	libboost-program-options-dev libbz2-dev zlib1g-dev libexpat1-dev pandoc clang-tidy \
	cppcheck iwyu doxygen dot2tex libproj-dev libgdal-dev libsparsehash-dev

RUN mkdir work
WORKDIR work

RUN git clone https://github.com/protocolbuffers/protobuf.git && \
	cd protobuf && \
	git submodule update --init --recursive && \
	./autogen.sh && \
	./configure && \
	make && \
	make check && \
	make install && \
	ldconfig

RUN git clone https://github.com/mapbox/protozero && \
	cd protozero && \
	mkdir build && \
	cd build && \
	cmake .. &&\
	make && \
	make install

RUN git clone https://github.com/osmcode/libosmium && \
	cd libosmium && \
	mkdir build && \
	cd build && \
	cmake -DCMAKE_BUILD_TYPE=Release -DBUILD_EXAMPLES=OFF -DBUILD_TESTING=OFF -DINSTALL_PROTOZERO=ON -DGEOS_INCLUDE_DIR=/usr/include/gdal/ -DGEOS_LIBRARY=/usr/lib .. && \
	make && \
	make install

RUN git clone https://github.com/osmcode/osmium-tool && \
	cd osmium-tool && \
	mkdir build && \
	cd build && \
	cmake .. && \
	make && \
	make install

RUN cd && rm -rf work
RUN apt-get clean
