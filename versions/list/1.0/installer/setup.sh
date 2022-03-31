#!/bin/bash

ssh_config=/etc/ssh/sshd_config
ftp_config=/etc/vsftpd.conf
enviroment=/etc/pBind/environment
tech_p=/home/tech/.profile
root_p=/root/.profile
PBIND_PATH=/home/server/pBind
backups=( ssh_config ftp_config tech_p root_p )
FTP_PORT=4021
SSH_PORT=4022

source $PBIND_PATH/utils/includes/functions.sh

#Create new First User
adduser --disabled-password --gecos "" tech
usermod -aG sudo tech

#Configure Services
echo "#INJECTED CONFIGURATIONS
local_root=/home/server
local_enable=YES
listen_port=${FTP_PORT}" >> $ftp_config
echo "#INJECTED CONFIGURATIONS
port=${SSH_PORT}
AllowUsers tech" >> $ssh_config

#Install Node Resources
title "Install Node Resources"
npm install npm -g 
warning "React"
npm install -g create-react-app
warning "Typescript"
npm install -g typescript
warning "Sass"
npm install -g sass
success "complete"

onload_code="\n#INJECTED CODE - pBind
source /etc/pBind/environment
pBind welcome
"

#create enviroment
title "Setup enviroment"
mkdir -p $PBIND_PATH/.bak
mkdir -p $(dirname $enviroment)
if [[ ! -f $enviroment ]];then
	touch $enviroment
	info "$enviroment created"
fi
success "complete"

#make backups
title "Backup hot files"
for el in "${backups[@]}";do
	cp $el $PBIND_PATH/.bak/
	success "$el bk created"
done
success "complete"

#Setup PBIND_PATH and pBind command
title "Setup Variables and commands"
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