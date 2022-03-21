# Configure App Creator
newDir=/home/server/app_$1
#Generate App Folder and start file
mkdir -p $newDir
echo -e "echo '[NODE]$1'\n
cd /home/server/$1\n
npm start">> $newDir/start.sh
chmod 777 $newDir/start.sh
cd $newDir
npx create-react-app $1 --template typescript