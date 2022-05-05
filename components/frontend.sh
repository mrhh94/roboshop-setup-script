#!/usr/bin/env bash

source components/common.sh
checkRootUser                     &>>${LOG_FILE}

 ECHO "Installing nginx"
 yum install nginx -y             &>>${LOG_FILE}
 checkStatus $?

 ECHO "Downloading frontend code files"
 curl -s -L -o /tmp/frontend.zip "http//github.com/roboshop-devops-project/frontend/archive/main.zip"    &>>${LOG_FILE}
 checkStatus $?

 cd /usr/share/nginx/html         &>>${LOG_FILE}

 ECHO "Removing old files"
 rm -rf *                         &>>${LOG_FILE}
 checkStatus $?

 ECHO "Unzipping frontend file"
 unzip /tmp/frontend.zip          &>>${LOG_FILE}
 checkStatus $?

 ECHO "Moving extracted files to other folder"
 mv frontend-main/* .             &>>${LOG_FILE}
 mv static/* .                    &>>${LOG_FILE}
 rm -rf frontend-main README.md   &>>${LOG_FILE}
 mv localhost.conf /etc/nginx/default.d/roboshop.conf    >/tmp/roboshop.log
 checkStatus $?

 ECHO "Enabling/Starting nginx"
 systemctl enable nginx           &>>${LOG_FILE}
 systemctl start nginx            &>>${LOG_FILE}
 systemctl restart nginx          &>>${LOG_FILE}
 checkStatus $?

 
