#!/bin/bash
function getValFromJson () {
jsonVal=$(grep -o "\"${1}\":\"[^\"]*" $2 | grep -o '[^"]*$')
}