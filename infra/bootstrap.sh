#!/usr/bin/env bash

SVC_USER=ec2-user
DOCKER_COMPOSE_VERSION=1.25.5
TARGET_DIR=/opt/verdaccio-s3-master

sudo yum update -y && sudo yum install -y wget unzip

sudo mkdir $TARGET_DIR && sudo chown -R $SVC_USER:$SVC_USER $TARGET_DIR

sudo curl -L \
  https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-$(uname -s)-$(uname -m) \
  -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

wget https://github.com/darvein/verdaccio-s3/archive/master.zip -O /tmp/master.zip
unzip /tmp/master.zip -d /opt/
rm /tmp/master.zip


cp ~/dotenv /opt/verdaccio/.env

cd /opt/verdaccio; make docker-run
