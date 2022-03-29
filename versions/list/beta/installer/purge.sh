#!/bin/bash
source /etc/environment

chown -R tech $(dirname $PBIND_PATH)
chmod -R 770 $(dirname $PBIND_PATH)
chmod -R 110 $PBIND_PATH

rm -f -r "${PBIND_PATH}/installer"

#useless
#if ! [ $# -eq 0 ] &&  [ $1 == "--uninstall" ];then
#rm -f -r "${PBIND_PATH}/"
#fi