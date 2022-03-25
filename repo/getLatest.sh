#!/bin/bash
NC="\033[0m"
R="\033[0;31m"
G="\033[0;32m"
C="\033[0;36m"
P="\033[0;35m"
W="\033[1;37m"

#curl -s "https://raw.githubusercontent.com/pBielli/pBind/master/repo/info.json" .checkInfos
function getValFromJson () {
jsonVal=$(grep -o "\"${1}\":\"[^\"]*" $2 | grep -o '[^"]*$')
}

key='version'
file='/home/server/pBind/repo/info.json'
getValFromJson $key $file
installed="$jsonVal"

tmpfile='/home/server/pBind/repo/.TMP_info.json'
#TEST:
url="https://raw.githubusercontent.com/pBielli/pBind/master/repo/fakeinfo.json"
#url="https://raw.githubusercontent.com/pBielli/pBind/master/repo/info.json"
curl -s -o "$tmpfile" $url
getValFromJson $key $tmpfile
latest="$jsonVal"

echo -e "\n[${W}pBind${NC}]\n  -v$installed"
rm "$tmpfile"

if [ -z "$latest" ]; then
        echo -e " [${R}error${NC}]\n  ${}retry.\n"
        bash /home/server/pBind/repo/getLatest.sh
        exit 1
fi

if [ "$installed" = "$latest" ]; then
    echo -e " ${G}Latest version installed.${NC}\n"
    exit 1
else
    echo -e " There is a new version:${C}$latest${NC}"
fi

read -p -e " ${W}Start update?${NC}(Y/n)" -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
    # do dangerous stuff
    echo -n " start updating"
    sleep 0.4
    echo -e "${G}started.${NC}"
    /home/server/pBind/repo/update.sh
fi
