#FileName:NodeJS container

FROM ubuntu:20.04
WORKDIR /home/server
EXPOSE 4000-4100/tcp
EXPOSE 4000-4100/udp

#CMD bash /home/server/pBind/startup.sh

# Create Folder
RUN mkdir -p /home/server  
# Install dependencies
RUN apt-get update && \
apt-get install sudo git vsftpd curl nano -y && \
sudo DEBIAN_FRONTEND=noninteractive apt-get -y install openssh-server
RUN curl -fsSL https://deb.nodesource.com/setup_17.x | sudo -E bash - && \
apt-get install -y nodejs

#Git Clone necessary files and apply config
RUN git clone https://github.com/pBielli/Dk_container.git /home/server/pBind && \
bash /home/server/pBind/configurations/setup.sh
