#!/bin/bash
gitDir=/home/server/pBind
git clone https://github.com/pBielli/pBind ${gitDir}_NEW
rm -d -r "${gitDir}"
mv ${gitDir}_NEW ${gitDir}

#apply config (remove unused) 
bash "${gitDir}/configurations/cleanup.sh"