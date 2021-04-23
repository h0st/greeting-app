ARG BASE_IMAGE_NAME
ARG BASE_IMAGE_VERSION
FROM $BASE_IMAGE_NAME:$BASE_IMAGE_VERSION as clang
ENV container=docker
ARG IMAGE_VERSION
ARG BUILD_DATE
USER root
RUN apt-get update && apt-get install -y xz-utils curl
RUN cd /tmp/ \
    && curl -SL https://github.com/llvm/llvm-project/releases/download/llvmorg-10.0.0/clang+llvm-10.0.0-x86_64-linux-gnu-ubuntu-18.04.tar.xz -# -o llvm.tar.xz \
    && mkdir clang-10/ \
    && tar xf ./llvm.tar.xz -C clang-10 --strip-components=1

FROM ubuntu:18.04 as ninja
RUN apt-get update \
    && apt-get install -y git clang python3
RUN mkdir -p /tmp/ && cd /tmp/ \
    && git clone https://github.com/ninja-build/ninja.git \
    && cd /tmp/ninja/ \
    && CXX=clang++ ./configure.py --bootstrap

# Main image
FROM ubuntu:18.04
COPY --from=clang /tmp/clang-10/bin/ /usr/bin/
COPY --from=clang /tmp/clang-10/lib/ /usr/lib/
COPY --from=ninja /tmp/ninja/ninja /usr/bin/
COPY hello.cpp /tmp
COPY build.ninja /tmp
RUN cd /tmp && ninja && cp /usr/local/bin
CMD [“hello”]

LABEL name=”Image for building a C++ using Ninja build tool”
LABEL image.based.on=”$BASE_IMAGE_NAME:$BASE_IMAGE_VERSION”
LABEL image.version=”$IMAGE_VERSION”
LABEL image.date=”$BUILD_DATE”
