#!/bin/bash
gitDir=/home/server/sh
rm -d -r "${gitDir}"
git clone https://github.com/pBielli/Dk_container.git ${gitDir}
#remove unused
rm "${gitDir}/README.md"
rm -d -r "${gitDir}/server_init"