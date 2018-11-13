#!/bin/bash
# 测试mysql Dockerfile
IMAGE_NAME=mysql-test
CONTAINER_NAME=mysql-test
docker container rm -f mysql-test
docker build --no-cache ./  -t ${IMAGE_NAME}
docker run --rm -d -p 3306:3306/tcp -p 33060:33060/tcp --name ${CONTAINER_NAME} ${IMAGE_NAME}:latest
docker exec -it ${IMAGE_NAME} sh -c  "cd /mysql/data && sleep 1 && ls"