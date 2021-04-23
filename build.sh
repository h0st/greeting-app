#!/usr/bin/env bash

argLine=””
buildData=$(date +”%Y-%m-%dT%H:%M”)
source ./image.conf

for arg in `cat image.conf`; do
  argLine=”$argLine –build-arg $arg”;
done

argLine=”$argLine –build-arg BUILD_DATE=$buildDate”
imagePath=”${IMAGE_NAME}”
imageName=”${imagePath}:{IMAGE_VERSION}”
docker build --rm=true -f Dockerfile ${argLine} -t ${imageName} .
docker tag ${imageName} “${imagePath}:latest”