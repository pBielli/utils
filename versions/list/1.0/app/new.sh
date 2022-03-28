# Configure App Creator
APP_NAME=$1
APPs_DIR=/home/server/apps
mkdir -p $APPs_DIR
cd $APPs_DIR
#Generate app
npx create-react-app $APP_NAME --template typescript