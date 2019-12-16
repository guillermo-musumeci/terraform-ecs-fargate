#!/bin/bash

sudo yum update -y
sudo amazon-linux-extras install nginx1.122 -y
export HOSTNAME=$(hostname | tr -d '\n')
export PRIVATE_IP=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)
echo "Welcome to $HOSTNAME - $PRIVATE_IP" > /usr/share/nginx/html/index.html
service nginx start