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
  exit 0
fi

ECHO "Download Application"
curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip"    &>>${LOG_FILE}
checkStatus $?

ECHO "Extract Application Archive"
cd /home/roboshop && rm -rf catalogue && unzip -o /tmp/catalogue.zip &>>${LOG_FILE} && mv catalogue-main catalogue
checkStatus $?
