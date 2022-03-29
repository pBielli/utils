#!/bin/bash
FTP_PORT=4021
SSH_PORT=4022
#Create new First User
adduser --disabled-password --gecos "" tech
usermod -aG sudo tech

#Configure Services
echo "#INJECTED CONFIGURATIONS
local_root=/home/server
local_enable=YES
listen_port=${FTP_PORT}" >> /etc/vsftpd.conf
echo "#INJECTED CONFIGURATIONS
port=${SSH_PORT}
AllowUsers tech" >> /etc/ssh/sshd_config

#Install Node Resources
npm install npm -g 
echo [React]
npm install -g create-react-app
echo [Typescript]
npm install -g typescript
echo [Sass]
npm install -g sass


#Setup PBIND_PATH
echo -e "\nPBIND_PATH=/home/server/pBind" >> /etc/environment

bash /home/server/pBind/configurations/welcome.sh