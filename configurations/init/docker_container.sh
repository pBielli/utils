#!/bin/bash
#echo -e "\n[\033[0;35mHello World!\033[0m]\ni'm working on this..."
curl -s -t Dockerfile "https://raw.githubusercontent.com/pBielli/pBind/master/configurations/Dockerfile"
docker build --tag="pb_node_server" .
docker run --hostname=pb_node_server --name=pb_node_server pb_node_server
