#!/usr/bin/env bash

source components/common.sh
checkRootUser $?                  &>>${LOG_FILE}

ECHO "Installing NODE.JS Repos"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash  &>>${LOG_FILE}
checkStatus $?

ECHO "Installing NODE.JS"
yum install nodejs gcc-c++ -y   &>>${LOG_FILE}
checkStatus $?

id roboshop &>>${LOG_FILE}
if [ $? -ne 0 ]; then
  ECHO "Add Application User"
  useradd roboshop    &>>${LOG_FILE}
  checkStatus $?
fi

ECHO "Download Application"
curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip"    &>>${LOG_FILE}
checkStatus $?

ECHO "Extract Application Archive"
cd /home/roboshop && rm -rf catalogue && unzip -o /tmp/catalogue.zip &>>${LOG_FILE} && mv catalogue-main catalogue
checkStatus $?

ECHO "Installing NPM"
cd /home/roboshop/catalogue && npm install  &>>${LOG_FILE}
checkStatus $?

ECHO "Updating SystemD file "
sed -i -e 's/MONGO_DNSNAME/172.31.28.217/' /home/roboshop/catalogue/systemd.service
checkStatus $?

ECHO "Setup SystemD Service"
mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service
systemctl daemon-reload       &>>${LOG_FILE}
systemctl start catalogue     &>>${LOG_FILE}
systemctl enable catalogue    &>>${LOG_FILE}
checkStatus $?


