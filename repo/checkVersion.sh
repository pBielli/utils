#!/bin/bash
#curl -s "https://raw.githubusercontent.com/pBielli/pBind/master/repo/info.json" .checkInfos

function getValFromJson () {
return $(grep -o '"$1":"[^"]*' $2 | grep -o '[^"]*$')
}
key="version"
val=$(getValFromJson ${key} /home/server/pBind/repo/info.json)
echo "actual:${val}"

remote_file="/home/server/pBind/repo/.tmp_info.json"
curl "https://raw.githubusercontent.com/pBielli/pBind/master/repo/info.json" $remote_file
val=$(getValFromJson $key $remote_file)
echo "latest:${val}"  
rm $remote_file