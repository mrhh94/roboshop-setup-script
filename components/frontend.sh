#!/usr/bin/env bash

source components/common.sh
checkRootUser           >/tmp/roboshop.log

 echo "Installing nginx"
 yum install nginx -y             >/tmp/roboshop.log

 echo "Downloading frontend code files"
 curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip"    >/tmp/roboshop.log

 cd /usr/share/nginx/html         >/tmp/roboshop.log

 echo "removing old files"
 rm -rf *                         >/tmp/roboshop.log

 echo "unzipping frontend file"
 unzip /tmp/frontend.zip          >/tmp/roboshop.log
 echo "successfully extracted all files"

 echo "moving extracted files to other folder"
 mv frontend-main/* .             >/tmp/roboshop.log
 mv static/* .                    >/tmp/roboshop.log
 rm -rf frontend-main README.md   >/tmp/roboshop.log
 mv localhost.conf /etc/nginx/default.d/roboshop.conf    >/tmp/roboshop.log

 echo "enabling nginx"
 systemctl enable nginx           >/tmp/roboshop.log
 systemctl start nginx            >/tmp/roboshop.log
 systemctl restart nginx          >/tmp/roboshop.log


 
