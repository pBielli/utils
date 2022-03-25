#!/bin/bash
#curl -s "https://raw.githubusercontent.com/pBielli/pBind/master/repo/info.json" .checkInfos

getValFromJson (key,file) {
return $(grep -o '"${key}":"[^"]*' ${file} | grep -o '[^"]*$')
}
key="version"
val=$(getValFromJson(${key},/home/server/pBind/repo/info.json))
echo "actual:${val}"
echo "actual:${getValFromJson(${key},/home/server/pBind/repo/info.json)}"
curl "https://raw.githubusercontent.com/pBielli/pBind/master/repo/info.json" ${remote_file}
val=$(getValFromJson(${key},${remote_file}))
echo "latest:${val}" 