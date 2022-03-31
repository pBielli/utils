#!/bin/bash
source /etc/pBind/environment

APP_NAME=$1
APPs_DIR="$(dirname $PBIND_PATH)/${APP_NAME}"
echo "[NODE]$APP_NAME"
cd $APPs_DIR
npm start