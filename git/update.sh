#!/bin/bash
gitDir=/home/server/pBind
rm -d -r "${gitDir}"
git clone https://github.com/pBielli/pBind ${gitDir}
#remove unused
rm "${gitDir}/README.md"
rm -d -r "${gitDir}/server_init"