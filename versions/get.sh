#!/bin/bash
apt-get install jq -y
apt-get install subversion -y

#Graphic Functions
function hr () {echo -e "  ______________________\n"}
function list_el () {echo -e "  [$1] $2"}

#Logic functions
function getVersion () {
curl https://raw.githubusercontent.com/pBielli/pBind/master/versions/list.json | jq -c ".[] | select( .type==\"$1\").name"
}

#Preparing the list of versions
all_versions=""
versions=("1.0","beta")
for index in "${!versions[@]}"
do
	version=$(curl "https://raw.githubusercontent.com/pBielli/pBind/master/versions/list/${versions[index]}/info.json" | jq -c ".version")
    if [ $index == 0];then
	 all_versions="$(list_el $index $version)"
	else
	 all_versions="${all_versions}\n$(list_el $index $version)"
	fi
done
stable=$(getVersion stable)
latest=$(getVersion latest)
beta=$(getVersion beta)

while [[ ! $CH =~ ^[0-3]{1} ]]; do
echo " [VERSION]"
list_el 0 "custom"
list_el 1 "stable:${stable}"
list_el 2 "latest:${latest}"
list_el 3 "beta:  ${beta}"
echo -e "\n${all_versions}"
hr

read -n 1 -p "  selection: " CH
echo ""

if [ $CH == 0 ];then
    read -p "  version: " VERSION
fi
hr

done

if [ $CH == 1 ];then
 VERSION="$stable"
fi
if [ $CH == 2 ];then
 VERSION="$stable"
fi
if [ $CH == 3 ];then
 VERSION="$stable"
fi
if (($CH >= 4 && $CH < (4+${#versions[@]})  ));then
 i=$(($CH-4))
 VERSION="${versions[i]}"
fi

source /etc/environment

#else, or after it, download the repo
svn export https://github.com/pBielli/pBind/trunk/versions/$VERSION $PBIND_PATH

if [ -z ${PBIND_PATH+x}];then
#unset, so install it completelly
	bash $(find "pBind/" -name "install.sh")
	bash $(find "pBind/" -name "setup.sh")
fi

bash $(find "pBind/" -name "purge.sh")
