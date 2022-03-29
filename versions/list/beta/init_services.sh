# Configure Startup Services File
source /etc/environment
source "${PBIND_PATH}/utils/includes/colors.sh"

echo -e "[${BGreen}SERVER STARTUP${NC}]
  loading..."
service ssh restart
service vsftpd restart
#service nodejs restart
echo -e "[${Green}started${NC}\n"