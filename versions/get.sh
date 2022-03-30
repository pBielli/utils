#!/bin/bash

#COLORS
# Reset
NC='\033[0m'       # Text Reset

# Regular Colors
Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'        # White

# Bold
BBlack='\033[1;30m'       # Black
BRed='\033[1;31m'         # Red
BGreen='\033[1;32m'       # Green
BYellow='\033[1;33m'      # Yellow
BBlue='\033[1;34m'        # Blue
BPurple='\033[1;35m'      # Purple
BCyan='\033[1;36m'        # Cyan
BWhite='\033[1;37m'       # White

#Graphic Functions
function hr () {
echo -e "  ______________________\n"
}
function title () {
echo -e " [ ${BGreen}${1}${NC} ] ${BGray}${2}${NC} $3"
}
function success () {
echo -e " [V][ ${BGreen}success${NC} ] ${1}"
}
function error () {
echo -e " [X][ ${BRed}error${NC} ] ${1}"
}
function warning () {
echo -e " [!][ ${BOrange}warning${NC} ] ${1}"
}
function list_el () {
echo -e "  [$1] ${BWhite}${2}${NC}"
}
function prompt () {
read -p "  ${BWhite}${1}${NC}: " INPUT
echo $INPUT
}

#Logic functions
function getVersion () {
curl -s https://raw.githubusercontent.com/pBielli/pBind/master/versions/list.json | jq -c ".[] | select( .type==\"$1\").version"
}
function getInfoFile () {
curl -s "https://raw.githubusercontent.com/pBielli/pBind/master/versions/list/${1}/info.json"
}

clear
success "\nLoading..."
#apt-get install jq -y
#apt-get install subversion -y

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


while [[ ! $CH =~ ^[0-$last_i]{1} ]]
do
clear
echo
title "VERSION"
list_el 0 "input"
list_el 1 "stable:${stable}"
list_el 2 "beta:  ${beta}"
echo -e "${all_versions}"
hr

CH=$(prompt "selection")

if [ $CH == 0 ];then
	VERSION=$(prompt "version")
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

success "selected version: v${VERSION}"

##################################################################################
source /etc/environment
PBIND=/home/server/pBind

print_base "proceed to "

rm -r -f "${PBIND}"
#else, or after it, download the repo
svn export "https://github.com/pBielli/pBind/trunk/versions/list/$VERSION" "${PBIND}"
if ! [ -d "${PBIND}" ];then
exit 1
fi
while (( $ACTION != "u" || $ACTION != "i" )) 
do 
ACTION=$(prompt "install or upgrade?(i/u)")
done


if [ $ACTION == "i" ];then
#unset, so install it completelly
        bash $(find "pBind/" -name "install.sh")
        bash $(find "pBind/" -name "setup.sh")
fi

bash $(find "pBind/" -name "purge.sh")                           