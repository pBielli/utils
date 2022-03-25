#!/bin/bash
adduser --disabled-password --gecos "" tech
usermod -aG sudo tech

echo "local_root=/home/server
local_enable=YES
listen_port=4021" >> /etc/vsftpd.conf
echo "port=4022
AllowUsers tech">> /etc/ssh/sshd_config

#Install Node Resources
npm install npm -g 
echo [React]
npm install -g create-react-app
echo [Typescript]
npm install -g typescript
echo [Sass]
npm install -g sass

chown -R tech /home/server/
chmod -R 770 /home/server/
chmod -R 110 /home/server/pBind