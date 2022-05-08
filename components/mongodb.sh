#!/usr/bin/env bash

source components/common.sh

checkRootUser $1                     &>>${LOG_FILE}

ECHO "Installing MongoDB"
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo    &>>${LOG_FILE}
checkRootUser $1                    &>>${LOG_FILE}
yum install -y mongodb-org          &>>${LOG_FILE}
systemctl enable mongod             &>>${LOG_FILE}
ECHO "MongoDB Installed"

sed -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf      &>>${LOG_FILE}

systemctl restart mongod            &>>${LOG_FILE}


ECHO "Unzipping Files"
curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip" &>>${LOG_FILE}
cd /tmp
unzip mongodb.zip   &>>${LOG_FILE}
cd mongodb-main
ECHO "Unzipping Successful"



mongo < catalogue.js    &>>${LOG_FILE}
mongo < users.js        &>>${LOG_FILE}

systemctl restart mongod            &>>${LOG_FILE}

ECHO " MongoDB Started Successfully"