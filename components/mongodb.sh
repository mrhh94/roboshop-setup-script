#!/usr/bin/env bash

source components/common.sh
checkRootUser

ECHO "Setup MongoDB repos"
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo  &>>${LOG_FILE}
checkStatus $?

ECHO "Install MongoDB"
yum install -y mongodb-org  &>>${LOG_FILE}
checkStatus $?

ECHO "Start MongoDB Service"
systemctl enable mongod     &>>${LOG_FILE}
systemctl start mongod      &>>${LOG_FILE}
checkStatus $?

ECHO "Updating Listen IP address"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
systemctl restart mongod    &>>${LOG_FILE}
checkStatus $?

ECHO "Download the schema"
curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip"  &>>${LOG_FILE}
checkStatus $?

ECHO "Load the Schema"
cd /tmp && unzip -o mongodb.zip &>>${LOG_FILE} && cd mongodb-main && mongo < catalogue.js &>>${LOG_FILE} && mongo < users.js   &>>${LOG_FILE}
systemctl restart mongod    &>>${LOG_FILE}
checkStatus $?

ECHO "MongoDB is Ready to Use"





