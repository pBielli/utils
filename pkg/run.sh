#!/bin/bash
tmpFilePath=/home/server/sh/git/tmp
curl -s -o $tmpFilePath $1
bash $tmpFilePath
rm $tmpFilePath