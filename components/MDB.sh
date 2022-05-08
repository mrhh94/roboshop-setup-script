#!/usr/bin/env bash

source components/common.sh
checkRootUser

#curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo
# yum install -y mongodb-org
# systemctl enable mongod
# systemctl start mongod
# 1. Update Listen IP address from 127.0.0.1 to 0.0.0.0 in config file
# Config file: `/etc/mongod.conf`
# systemctl restart mongod
# curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip"

# cd /tmp
# unzip mongodb.zip
# cd mongodb-main
# mongo < catalogue.js
# mongo < users.js

# systemctl restart mongod
ECHO "Setup MongoDB repos"
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo
checkStatus $?

ECHO "Install MongoDB"
yum install -y mongodb-org
checkStatus $?

ECHO "Start MongoDB Service"
systemctl enable mongod
systemctl start mongod
checkStatus $?

ECHO "Updating Listen IP address"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
systemctl restart mongod
checkStatus $?

ECHO "Download the schema"
curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip"
checkStatus $?

ECHO "Load the Schema"
cd /tmp && unzip mongodb.zip && cd mongodb-main && mongo < catalogue.js && mongo < users.js
systemctl restart mongod
checkStatus $?

ECHO "MongoDB is Ready to Use"





