
FROM ubuntu:16.04
LABEL Name=ubuntu Version=0.0.1
COPY ./resources/sources.list /etc/apt/sources.list
RUN apt-get -y update && apt-get install -y \
    vim \
    php