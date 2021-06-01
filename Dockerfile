FROM ubuntu:18.04 as ninja-stage
ENV container=docker

RUN apt-get update \
    && apt-get install -y git clang python3 
RUN mkdir -p /tmp/ && cd /tmp/ \
    && git clone https://github.com/ninja-build/ninja.git \
    && cd /tmp/ninja/ \
    && CXX=clang++ ./configure.py --bootstrap \
	&& cp ninja /usr/bin
COPY hello.cpp build.ninja /tmp/
RUN cd /tmp && ninja

FROM ubuntu:18.04
COPY --from=ninja-stage /tmp/ninja/ninja /usr/bin/
COPY --from=ninja-stage /tmp/hello /usr/bin/hello
CMD ["/bin/bash"]

ARG BASE_IMAGE_NAME
ARG BASE_IMAGE_VERSION
ARG IMAGE_VERSION
ARG BUILD_DATE

LABEL name="Image for building a C++ app using Ninja build tool"
LABEL image.based.on="$BASE_IMAGE_NAME:$BASE_IMAGE_VERSION"
LABEL image.version="$IMAGE_VERSION"
LABEL image.date="$BUILD_DATE"
