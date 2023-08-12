#!/bin/bash
myuser=$(whoami)

sudo apt-get update
sudo apt -y install software-properties-common
sudo curl -sL https://deb.nodesource.com/setup_12.x | sudo bash  -
sudo apt-get update
sudo apt-get install -y nginx apache2-utils postgresql redis nodejs zip unzip php7.4 php7.4-fpm php7.4-pgsql php7.4-memcache php7.4-cli php7.4-json php7.4-common php7.4-mysql php7.4-zip php7.4-gd php7.4-mbstring php7.4-curl php7.4-xml php7.4-bcmath
sudo php composer-setup.php --install-dir=/usr/bin --filename=composer
sudo rm -f composer-setup.php

sudo systemctl start php7.4-fpm
sudo systemctl start postgresql
sudo systemctl start redis-server
sudo systemctl enable nginx
sudo systemctl enable php7.4-fpm
sudo systemctl enable postgresql
sudo systemctl enable redis-server

sudo npm install yarn -g
wget https://go.dev/dl/go1.20.5.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.20.5.linux-amd64.tar.gz
sudo ln -s /usr/local/go/bin/go /usr/bin/go
sudo ln -s /usr/local/go/bin/gofmt /usr/bin/gofmt
clear

echo " ______            _____ ____ _______ "
echo "|  ____|          / ____|  _ \__   __|"
echo "| |__  __  _____ | |    | |_) | | |   "
echo "|  __| \ \/ / _ \| |    |  _ <  | |   "
echo "| |____ >  < (_) | |____| |_) | | |   "
echo "|______/_/\_\___/ \_____|____/  |_|   " 
echo "Script Builder by Github(@shinau21)"
echo ""
read -p "Masukan IP : " varip
read -p "Masukan User DB : " userdb
read -p "Masukan Pass DB : " passdb
read -p "Masukan DB : " dbname

sudo cp conf/server.conf /etc/nginx/sites-available/
sudo sed -i "s#/var/www#${HOME}#g" /etc/nginx/sites-available/server.conf
sudo ln -s /etc/nginx/sites-available/server.conf /etc/nginx/sites-enabled/server.conf

sudo su postgres <<EOF
psql -c 'create database ${dbname};'
psql -c "create user ${userdb} with encrypted password '${passdb}';"
psql -c 'grant all privileges on database ${dbname} to ${userdb};'
EOF

sudo rm /etc/nginx/sites-enabled/default

mkdir ~/server
cd ~/server/
git clone https://github.com/shellrean-dev/exo-cbt-service -b ristretto exo-cbt-service-1
git clone https://github.com/shellrean-dev/exo-cbt-client -b ristretto exo-cbt-client-1
git clone https://github.com/shellrean-dev/exo-cbt-socket exo-cbt-socket-1
git config --global --add safe.directory /home/${myuser}/server/exo-cbt-service-1
git config --global --add safe.directory /home/${myuser}/server/exo-cbt-client-1

cd exo-cbt-service-1/
cp .env.example .env
sed -i "s#APP_URL=http://localhost/#APP_URL=http://${varip}/#g" .env
sed -i "s#DB_USERNAME=postgres#DB_USERNAME=${userdb}#g" .env
sed -i "s#DB_DATABASE=exo_cbt#DB_DATABASE=${dbname}#g" .env
sed -i "s#DB_PASSWORD=postgres#DB_PASSWORD=${passdb}#g" .env
sed -i "s#EXO_ENABLE_CACHING=#EXO_ENABLE_CACHING=oke#g" .env
sed -i "s#EXO_ENABLE_SOCKET=no#EXO_ENABLE_SOCKET=oke#g" .env
sed -i "s#MIX_SOCKET_URL=http://localhost:3000#MIX_SOCKET_URL=http://${varip}:8888#g" .env
sed -i 's#SOCKET}#SOCKET}"#g' .env
sed -i "s#3.1.0#3.17.0#g" .env
composer install
php artisan key:generate
yarn install
php artisan storage:link
php artisan migrate
php artisan db:seed

cd ../exo-cbt-client-1/
cp .env-example .env
sed -i "s#VUE_APP_URL=#VUE_APP_URL=http://${varip}#g" .env
sed -i "s#VUE_APP_SOCKET=#VUE_APP_SOCKET=http://${varip}:8888#g" .env
sed -i "s#VUE_APP_ENABLE_SOCKET=false#VUE_APP_ENABLE_SOCKET=oke#g" .env
sed -i "s#v3.0.2 - ristretto#3.17.0#g" .env
yarn install
yarn build

cd ../exo-cbt-socket-1/
cp .env.example .env
yarn install
sudo npm install pm2 -g
pm2 start server.js
pm2 startup systemd -u ${myuser} --hp /home/${myuser}

cd ../../
sudo usermod -a -G www-data ${myuser}
sudo chown -R ${myuser}.www-data ~/server/
sudo chmod -R 775 ~/server/
sudo chmod -R 777 ~/server/exo-cbt-service-1/public/

sudo systemctl restart nginx

clear
echo " ______            _____ ____ _______ "
echo "|  ____|          / ____|  _ \__   __|"
echo "| |__  __  _____ | |    | |_) | | |   "
echo "|  __| \ \/ / _ \| |    |  _ <  | |   "
echo "| |____ >  < (_) | |____| |_) | | |   "
echo "|______/_/\_\___/ \_____|____/  |_|   " 
echo "Script Builder by Github(@shinau21)"
echo ""
echo "Build Selesai"
