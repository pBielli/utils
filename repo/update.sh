#!/bin/bash
gitDir=/home/server/pBind
rm -d -r "${gitDir}"
git clone https://github.com/pBielli/pBind ${gitDir}
#apply config (remove unused) 
bash "${gitDir}/configurations/cleanup.sh"