#!/usr/bin/env bash

source components/common.sh
checkRootUser           >/tmp/roboshop.log

 echo "Installing nginx"
 yum install nginx -y             >/tmp/roboshop.log
 checkStatus $1

 echo "Downloading frontend code files"
 curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip"    >/tmp/roboshop.log
 checkStatus $1

 cd /usr/share/nginx/html         >/tmp/roboshop.log

 echo "removing old files"
 rm -rf *                         >/tmp/roboshop.log
 checkStatus $1

 echo "unzipping frontend file"
 unzip /tmp/frontend.zip          >/tmp/roboshop.log
 checkStatus $1

 echo "moving extracted files to other folder"
 mv frontend-main/* .             >/tmp/roboshop.log
 mv static/* .                    >/tmp/roboshop.log
 rm -rf frontend-main README.md   >/tmp/roboshop.log
 mv localhost.conf /etc/nginx/default.d/roboshop.conf    >/tmp/roboshop.log
 checkStatus $1

 echo "enabling nginx"
 systemctl enable nginx           >/tmp/roboshop.log
 systemctl start nginx            >/tmp/roboshop.log
 systemctl restart nginx          >/tmp/roboshop.log
 checkStatus $1

 
