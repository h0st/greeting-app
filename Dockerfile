ARG BASE_IMAGE_NAME
ARG BASE_IMAGE_VERSION
FROM $BASE_IMAGE_NAME:$BASE_IMAGE_VERSION as clang-stage
ENV container=docker
ARG IMAGE_VERSION
ARG CLANG_VERSION
ARG BUILD_DATE
USER root
RUN apt-get update && apt-get install -y xz-utils curl
# NOTE: CLANG 12.0.0 doesn't exist for Ubuntu 18.04 ! 
RUN cd /tmp/ \
    && curl -SL https://github.com/llvm/llvm-project/releases/download/llvmorg-$CLANG_VERSION/clang+llvm-$CLANG_VERSION-x86_64-linux-gnu-$BASE_IMAGE_NAME-$$BASE_IMAGE_VERSION.tar.xz -# -o llvm.tar.xz \
    && mkdir clang-$CLANG_VERSION/ \
    && tar xf ./llvm.tar.xz -C clang-$CLANG_VERSION –strip-components=1

FROM $BASE_IMAGE_NAME:$BASE_IMAGE_VERSION as ninja-stage
RUN apt-get update \
    && apt-get install -y git clang python3RUN mkdir -p /tmp/ && cd /tmp/ \
    && git clone https://github.com/ninja-build/ninja.git \
    && cd /tmp/ninja/ \
    && CXX=clang++ ./configure.py –bootstrap

FROM $BASE_IMAGE_NAME:$BASE_IMAGE_VERSION
COPY --from=clang-stage /tmp/clang-$CLANG_VERSION/bin/ /usr/bin/
COPY --from=clang-stage /tmp/clang-$CLANG_VERSION/lib/ /usr/lib/
COPY --from=ninja-stage /tmp/ninja/ninja /usr/bin/
COPY hello.cpp /tmp
COPY build.ninja /tmp
RUN cd /tmp && ninja && cp hello /usr/local/bin
ENTRYPOINT [“hello”]

LABEL name="Image for building a C++ app using Ninja build tool and CLang"
LABEL image.based.on="$BASE_IMAGE_NAME:$BASE_IMAGE_VERSION"
LABEL image.version="$IMAGE_VERSION"
LABEL image.date="$BUILD_DATE"