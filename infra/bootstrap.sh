#!/usr/bin/env bash

DOCKER_COMPOSE_VERSION=1.25.5

sudo yum update -y
sudo yum install -y wget unzip

sudo curl -L \
  https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-$(uname -s)-$(uname -m) \
  -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose
