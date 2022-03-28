#!/bin/bash
#source /etc/environment
mv "list.json" "list.json.bak"
cd list
FLAG=0
LIST="../list.json"
for v in */; do
    if [ $FLAG != 1 ];then
		FLAG=1
		echo "[" >> $LIST
	else
		echo "," >> $LIST
	fi
	I=$(find ${v} -name "info.json")
	echo "$I" 
	cat "$I" >> $LIST
	#cat $LIST

done
	echo -e "\n]" >> $LIST
	echo -e "\n"
	cat $LIST
cd ../