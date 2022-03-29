#!/bin/bash
#clear
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
curl  "https://raw.githubusercontent.com/pBielli/pBind/master/versions/list/${1}/info.json"
}


#Preparing the list of versions
all_versions=""
versions=("1.0" "beta")
for index in "${!versions[@]}"
do
        infoF=$( getInfoFile "${versions[index]}" )
        echo $info
        echo "${versions[index]}"
        echo "https://raw.githubusercontent.com/pBielli/pBind/master/versions/list/${versions[index]}/info.json"
                version=$( $info | jq -c ".version")
    if [ $index == 0 ];then
         all_versions="$(list_el $index $version)"
        else
         all_versions="${all_versions}\n$(list_el $index $version)"
        fi
done
stable=$(getVersion stable)
beta=$(getVersion beta)
#latest=$(getVersion latest)


while [[ ! $CH =~ ^[0-3]{1} ]]; do
echo " [VERSION]"
list_el 0 "custom"
list_el 1 "stable:${stable}"
list_el 2 "beta:  ${beta}"
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
 VERSION="$beta"
fi
first_i=3
if (($CH >= $first_i && $CH < ($first_i+${#versions[@]})  ));then
 i=$(($CH-$first_i))
 VERSION="${versions[i]}"
fi

echo "VERSION:${VERSION}"
##################################################################################
source /etc/environment

#else, or after it, download the repo
svn export https://github.com/pBielli/pBind/trunk/versions/$VERSION $PBIND_PATH

if [ -z ${PBIND_PATH+x}];then
#unset, so install it completelly
        bash $(find "pBind/" -name "install.sh")
        bash $(find "pBind/" -name "setup.sh")
fi

bash $(find "pBind/" -name "purge.sh")                           