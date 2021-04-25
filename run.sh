#!/usr/bin/env bash
IMAGE="hello-from-image:latest"
#
echo "Building Docker image ..." 
./build.sh
echo "Finished ..."
docker images | grep hello-from-image
status=$?
#
if [ $status -eq 0 ]; then
  echo "Running a Docker container ... "
  docker run -it --rm --name hello $IMAGE hello
else
  echo "hello-from-image image not fould! Please rebuild image!"
  exit 1
fi