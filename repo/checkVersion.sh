#!/bin/bash
#curl -s "https://raw.githubusercontent.com/pBielli/pBind/master/repo/info.json" .checkInfos
ssh user@remote_host "cat remote_file.txt" | diff - local_file.txt