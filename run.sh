#!/usr/bin/env bash

#
echo "Building Docker image ..." 
./build.sh
echo "Finished ..."
docker images | grep hello-from-image
status=$?
#
if [ $status -eq 0 ]; then
  echo "Running a Docker container ... Press Ctrl-C for exist!"
  docker run -d -it --rm --name hello hello-from-image:latest
  docker logs hello
else
  echo "hello-from-image image not fould! Please rebuild image!"
  exit 1
fi