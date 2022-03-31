#!/bin/bash

SRV_DIR=/home/server 
# Create Folder
mkdir -p /home/server  
# Install dependencies
apt-get update
apt-get install sudo git vsftpd curl nano jq subversion -y
sudo DEBIAN_FRONTEND=noninteractive apt-get -y install openssh-server
curl -fsSL https://deb.nodesource.com/setup_17.x | sudo -E bash
apt-get install -y nodejs