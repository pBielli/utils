#!/bin/bash

function getVersion () {
curl https://raw.githubusercontent.com/pBielli/pBind/master/versions/list.json | jq -c ".versions[] | select( .name==\"$1\").version"
}


while [[ ! $CH =~ ^[0-3]{1} ]]; do
echo -e " [VERSION]
  [0] stable:$(getVersion stable)
  [1] latest:$(getVersion latest)
  [2] beta: $(getVersion beta)
  [3] custom
  ______________________
"
read -n 1 -p "  selection: " CH
echo ""

if [ $CH == 3 ];then
        read -p "  version: " VERSION
fi
echo -e "  ______________________\n"
done

if ((CH >= 0 && CH <= 2));then
VERSION="$CH"
fi

source /etc/environment

#else, or after it, download the repo
svn export https://github.com/pBielli/pBind/trunk/versions/$VERSION $PBIND_PATH

if [ -z ${PBIND_PATH+x}];then
#unset, so install it completelly
	bash $(find "pBind/" -name "ubuntu.sh")
	bash $(find "pBind/" -name "setup.sh")
fi

bash $(find "pBind/" -name "purge.sh")
