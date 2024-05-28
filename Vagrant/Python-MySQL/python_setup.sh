#!/bin/bash
#  Script Reference: https://www.digitalocean.com/community/tutorials/how-to-set-up-a-node-js-application-for-production-on-ubuntu-18-04


echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf > /dev/null

sudo mkdir /opt/PCC-DevOps-Bootcamp
sudo chown -R vagrant:vagrant /opt/PCC-DevOps-Bootcamp
sudo apt-get update
sudo apt install -y python3-dev build-essential
sudo apt install -y libssl1.1
sudo apt install -y libssl1.1=1.1.1f-1ubuntu2
sudo apt install -y libssl-dev
sudo apt install -y libmysqlclient-dev
sudo apt install -y python3.8-venv
sudo apt install -y libvirt-dev

git clone https://github.com/kjakedev/PCC-DevOps-Bootcamp.git /opt/PCC-DevOps-Bootcamp

cd /opt/PCC-DevOps-Bootcamp/Python/TodoFlask-MySQL`
sed -ie 's/localhost/192.1.1.11/g' app.py
python3 -m venv venv
source venv/bin/activate
pip install -U pip setuptools
pip install -r requirements.txt
sudo cp python-todo.service /etc/systemd/system/python-todo.service
sudo systemctl daemon-reload
sudo systemctl start python-todo
sudo systemctl enable python-todo
sudo systemctl status python-todo
export FLASK_APP=app.py
export FLASK_ENV=development


