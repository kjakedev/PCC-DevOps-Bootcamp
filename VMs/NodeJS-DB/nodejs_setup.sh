#!/bin/bash
#  Script Reference: https://www.digitalocean.com/community/tutorials/how-to-set-up-a-node-js-application-for-production-on-ubuntu-18-04


echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf > /dev/null

cd ~
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
source ~/.nvm/nvm.sh
echo "source ~/.nvm/nvm.sh" >> ~/.bashrc
nvm install v18.12.1
sudo mkdir /opt/PCC-DevOps-Bootcamp
sudo chown -R vagrant:vagrant /opt/PCC-DevOps-Bootcamp

git clone https://github.com/kjakedev/PCC-DevOps-Bootcamp.git /opt/PCC-DevOps-Bootcamp


npm install pm2 -g
cd /opt/PCC-DevOps-Bootcamp/NodeJS/ToDoNodeJS-MySQL
npm install
npm run build-prod
cd dist
DB_HOST=192.1.1.11 DB_USER=test DB_PASSWORD=test DB_NAME=test pm2 start bundle.js
pm2 startup systemd

sudo env PATH=$PATH:/usr/bin /usr/lib/node_modules/pm2/bin/pm2 startup systemd -u vagrant --hp /home/vagrant
pm2 save

