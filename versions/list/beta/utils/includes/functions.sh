#!/bin/bash
function getValFromJson () {
QUERY=".[] | select( .name==\"${2}\")"
if [ $# -eq 3 ];then
QUERY="${QUERY}.${3}"
fi
$1 | jq -c "$QUERY"
}