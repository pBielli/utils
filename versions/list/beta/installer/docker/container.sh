#!/bin/bash
<<<<<<< HEAD:versions/list/beta/installer/docker/container.sh
echo -e "\n[\033[0;35mHello World!\033[0m]\ni'm working on this..."

=======
#echo -e "\n[\033[0;35mHello World!\033[0m]\ni'm working on this..."
curl -s -o Dockerfile "https://raw.githubusercontent.com/pBielli/pBind/master/configurations/Dockerfile"
docker build --tag="pb_node_server" .
docker run -t -i --no-cache -P --hostname=pb_node_server --name=pb_node_server pb_node_server
>>>>>>> 7b31c7c5cbd1363599a421ae4a3d41d715b27106:configurations/init/docker_container.sh
