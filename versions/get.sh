#!/bin/bash
clear
echo "Loading..."
#apt-get install jq -y
#apt-get install subversion -y

#Graphic Functions
function hr () {
echo -e "  ______________________\n"
}
function list_el () {
echo -e "  [$1] $2"
}

#Logic functions
function getVersion () {
curl -s https://raw.githubusercontent.com/pBielli/pBind/master/versions/list.json | jq -c ".[] | select( .type==\"$1\").version"
}
function getInfoFile () {
curl -s "https://raw.githubusercontent.com/pBielli/pBind/master/versions/list/${1}/info.json"
}


#Preparing the list of versions
all_versions=""
versions=("1.0" "beta")
first_i=3
last_i=$(($first_i+${#versions[@]}))
for index in "${!versions[@]}"
do
        info=$( getInfoFile "${versions[index]}" )
        version=$( echo $info | jq -c ".version")

    if [ $index > 0 ];then
         all_versions="${all_versions}\n"
    fi
    all_versions="${all_versions}$(list_el $(($index+$first_i)) $version)"


done
stable=$(getVersion stable)
beta=$(getVersion beta)
#latest=$(getVersion latest)


while [[ ! $CH =~ ^[0-$last_i]{1} ]]; do
clear
echo " [VERSION]"
list_el 0 "custom"
list_el 1 "stable:${stable}"
list_el 2 "beta:  ${beta}"
echo -e "${all_versions}"
hr

read -p "  selection: " CH
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
 VERSION="$beta"
fi
if (($CH >= $first_i && $CH < $last_i));then
 i=$(($CH-$first_i))
 VERSION="${versions[i]}"
fi

echo "VERSION:${VERSION}"

##################################################################################
source /etc/environment

rm -rf "/home/server/pBind"
#else, or after it, download the repo
svn export "https://github.com/pBielli/pBind/trunk/versions/list/$VERSION" "/home/server/pBind"

if [ -z ${PBIND_PATH+x} ];then
#unset, so install it completelly
        bash $(find "pBind/" -name "install.sh")
        bash $(find "pBind/" -name "setup.sh")
fi

bash $(find "pBind/" -name "purge.sh")                           