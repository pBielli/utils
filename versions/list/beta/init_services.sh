# Configure Startup Services File
source /etc/environment
source "${PBIND_PATH}/utils/includes/functions.sh"

if (($1 == "STOP" || $1 == "stop" ||$1 == "kill" ||$1 == "-s"));then
title "SERVER" "services ${Red}stop" "ssh,ftp"
list_element "1/2" "SSH"
service ssh stop
list_element "1/2" "FTP"
service vsftpd stop
success "started"
else
title "SERVER" "services ${Green}start" "ssh,ftp"
list_element "1/2" "SSH"
service ssh restart
list_element "1/2" "FTP"
service vsftpd restart
success "started"
fi