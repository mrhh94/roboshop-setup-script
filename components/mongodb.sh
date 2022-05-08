#!/usr/bin/env bash

source components/common.sh

checkRootUser                 &>>${LOG_FILE}

ECHO "Installing MongoDB"
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo    &>>${LOG_FILE}
yum install -y mongodb-org  &>>${LOG_FILE} && systemctl enable mongod  &>>${LOG_FILE} && systemctl start mongod   &>>${LOG_FILE}
checkStatus $?

ECHO "Configuring IP ADDRESS"
sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf      &>>${LOG_FILE}
checkStatus $?

systemctl restart mongod

ECHO "Unzipping Files"
#curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip" &>>${LOG_FILE}
curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip"  >>${LOG_FILE}
curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip" &&

cd /tmp
unzip mongodb.zip   &>>${LOG_FILE}
checkStatus $?

ECHO "Downloading Schema"
cd mongodb-main
mongo < catalogue.js  &>>${LOG_FILE}
mongo < users.js        &>>${LOG_FILE}
checkStatus $?

systemctl restart mongod            &>>${LOG_FILE}
ECHO "MongoDB Starting"
checkStatus $?

