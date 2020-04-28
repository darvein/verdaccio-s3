#!/usr/bin/env bash

SVC_USER=ec2-user
DOCKER_COMPOSE_VERSION=1.25.5
TARGET_DIR=/opt/verdaccio-s3-master
TARBALL_ZIP=https://github.com/darvein/verdaccio-s3/archive/master.zip

sudo yum update -y && sudo yum install -y wget unzip
sudo amazon-linux-extras install nginx1.12 -y

sudo mkdir $TARGET_DIR \
  && sudo chown -R $SVC_USER:$SVC_USER $TARGET_DIR

sudo curl -L \
  https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-$(uname -s)-$(uname -m) \
  -o /usr/local/bin/docker-compose &&
  sudo chmod +x /usr/local/bin/docker-compose

wget $TARBALL_ZIP -O /tmp/master.zip \
  && unzip /tmp/master.zip -d /opt/

# Setup and run verdaccio
cp ~/dotenv $TARGET_DIR/.env
source $TARGET_DIR/.env
cd $TARGET_DIR \
  && make httpasswd \
  && make docker-run

# Setup nginx frontend server
sudo systemctl enable nginx
sudo mkdir -p /etc/nginx/sites-enabled
sudo cp /etc/nginx/nginx.conf.default /etc/nginx/nginx.conf
sudo sed  -i '/^http {/a \\tinclude /etc/nginx/sites-enabled\/\*;' /etc/nginx/nginx.conf
sudo bash -c 'cat << EOF > /etc/nginx/sites-enabled/verdaccio
server {
    listen 80 default_server;
    access_log /var/log/nginx/verdaccio.log;
    charset utf-8;

    location / {
      proxy_set_header X-Real-IP \$remote_addr;
      proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
      proxy_set_header Host \$host;
      proxy_set_header X-NginX-Proxy true;
      proxy_pass http://localhost:4873;
      proxy_redirect off;
    }
}
EOF'
sudo service nginx restart

# Clean up
rm ~/dotenv
rm /tmp/master.zip
