#!/bin/bash

#Create new First User
adduser --disabled-password --gecos "" tech
usermod -aG sudo tech

#Configure Services
echo "#INJECTED CONFIGURATIONS
local_root=/home/server
local_enable=YES
listen_port=4021" >> /etc/vsftpd.conf
echo "#INJECTED CONFIGURATIONS
port=4022
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

bash /home/server/pBind/server/welcome.sh

bash /home/server/pBind/server/config.sh
