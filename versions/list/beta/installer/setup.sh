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

enviroment=/etc/environment
tech_p=/home/tech/.profile
root_p=/root/.profile
ssh_config=/root/.profile
root_p=/root/.profile
PBIND_PATH=/home/server/pBind

onload_code="\n#INJECTED CODE - pBind
source /etc/environment
pBind welcome
"
mkdir $PBIND_PATH/.bak
cp enviroment $PBIND_PATH/.bak/
cp tech_p $PBIND_PATH/.bak/
cp root_p $PBIND_PATH/.bak/

#Setup PBIND_PATH and pBind command
echo -e "\n#INJECTED CODE - pBind
PBIND_PATH=$PBIND_PATH
function pBind  {
bash \$PBIND_PATH/run.sh $@
}" >> $enviroment

#Setup including bash command on login
echo -e "${onload_code}" >> tech_p
echo -e "${onload_code}" >> root_p

mkdir -p $(dirname $PBIND_PATH)/apps
bash $PBIND_PATH/configurations/welcome.sh