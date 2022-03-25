#!/bin/bash
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
#url="https://raw.githubusercontent.com/pBielli/pBind/master/repo/fakeinfo.json"
url="https://raw.githubusercontent.com/pBielli/pBind/master/repo/info.json"
curl -s -o "$tmpfile" $url
getValFromJson $key $tmpfile
latest="$jsonVal"

echo "installed: $installed"
echo "latest:    $latest"
rm "$tmpfile"

if [ -z "$latest" ]; then
        echo error. retry.
        bash /home/server/pBind/repo/getLatest.sh
        exit 1
fi

if [ "$installed" = "$latest" ]; then
    echo "Latest version installed."
    exit 1
else
    echo "There is a new version:$latest"
fi

read -p " Update?(Y/n) " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
    # do dangerous stuff
    echo "start updating"
    sleep 0.4
    echo "started."
    /home/server/pBind/repo/update.sh
fi
