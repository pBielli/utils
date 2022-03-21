# Configure Startup Services File
echo -e "[\033[0;35mSERVER STARTUP\033[0m]
loading..."
service ssh restart
service vsftpd restart
#service nodejs restart
echo -e "[\033[0;32mstarted\033[0m]\n"