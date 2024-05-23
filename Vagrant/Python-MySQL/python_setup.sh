#!/bin/bash
#  Script Reference: https://www.digitalocean.com/community/tutorials/how-to-set-up-a-node-js-application-for-production-on-ubuntu-18-04


echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf > /dev/null

sudo mkdir /opt/PCC-DevOps-Bootcamp
sudo chown -R vagrant:vagrant /opt/PCC-DevOps-Bootcamp
sudo apt-get update
sudo apt install -y python3.8-venv

git clone https://github.com/kjakedev/PCC-DevOps-Bootcamp.git /opt/PCC-DevOps-Bootcamp

cd /opt/PCC-DevOps-Bootcamp/Python/TodoFlask-MySQL
sed -ie 's/localhost/192.1.1.11/g' app.py
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
export FLASK_APP=app.py
export FLASK_ENV=development
flask run


