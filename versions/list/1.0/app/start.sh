#!/bin/bash
APP_NAME=$1
echo "[NODE]$APP_NAME"
cd /home/server/apps/$APP_NAME
npm start