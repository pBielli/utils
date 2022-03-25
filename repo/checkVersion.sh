#!/bin/bash
#curl -s "https://raw.githubusercontent.com/pBielli/pBind/master/repo/info.json" .checkInfos

getValFromJson (key,file) {
return $(grep -o '"${key}":"[^"]*' ${file} | grep -o '[^"]*$')
}
key="version"
echo "actual:${getValFromJson(${key},/home/server/pBind/repo/info.json)}"
echo "latest:${getValFromJson(${key},$(curl https://raw.githubusercontent.com/pBielli/pBind/master/repo/info.json))}"