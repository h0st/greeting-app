#!/usr/bin/env bash

argLine=""
buildDate=$(date +"%Y-%m-%dT%H:%M")
echo $buildData

source ./image.conf

echo "Dir files:"
for file in `ls`; do
	echo $file
done

for arg in `cat image.conf`; do
  argLine="$argLine --build-arg $arg";
done

argLine="$argLine --build-arg BUILD_DATE=${buildDate}"
echo $argLine
imagePath="${IMAGE_NAME}"
imageName="${imagePath}:${IMAGE_VERSION}"
#docker_build_cmd="
docker build --rm=true -f Dockerfile ${argLine} -t ${imageName} .
#echo "CMD build: $docker_build_cmd"
#`$docker_build_cmd`
if [ $? -eq 0 ]; then
	docker_tag_cmd="docker tag ${imageName} ${imagePath}:latest"
	echo "CMD tag: $docker_tag_cmd"
	`$docker_tag_cmd`
else
	echo "[ERROR] Docker build command failed!"
	exit 1
fi

exit 0