#!/bin/bash
if [ $# -eq 1 ];then
	URL="https://raw.githubusercontent.com/pBielli/pBind/master/${1}"
else
	URL="https://raw.githubusercontent.com/${2}/master/${1}"
fi
curl -s $URL | bash