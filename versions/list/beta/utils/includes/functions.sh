#!/bin/bash
source "${PBIND_PATH}/utils/includes/colors.sh"
function getValFromJson () {
QUERY=".[] | select( .name==\"${2}\")"
if [ $# -eq 3 ];then
QUERY="${QUERY}.${3}"
fi
$1 | jq -c "$QUERY"
}

function hr () {
echo -e "  ______________________\n"
}
function title () {
echo -e " [ ${BGreen}${1}${NC} ] ${BGray}${2}${NC} $3"
}
function success () {
echo -e " [ ${BGreen}success${NC} ] ${1}"
}
function error () {
echo -e " [ ${BRed}error${NC} ] ${1}"
}
function warning () {
echo -e " [ ${BYellow}warning${NC} ] ${1}"
}
function list_el () {
echo -e "  [$1] ${BWhite}${2}${NC}"
}
function base_echo () {
echo -e "  ${2}${1}${NC} $3"
}
function setColor () {
echo -e "${1}"
}
function stopColor () {
echo -e "${NC}"
}

function prompt () {
read -p "  ${1}: " INPUT
echo $INPUT
}
