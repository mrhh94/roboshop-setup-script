#!/usr/bin/env bash

if [ -z "$1" ]; then
  echo "Instance argument required"
  exit 1
fi

NAME=$1

#aws ec2 describe-instances --filters Name=tag:Name,Values=test1 Name=state,Values=active
sudo aws ec2 describe-instances \
  --filters Name=tag:Name,Values="${NAME}" \
  --output table | grep 'InstanceId' &>>/dev/nul2.0

if [ $? -eq 0 ]; then
  echo " ${NAME} Instance Already Exists"
  exit 0
fi

AMI_ID=$(
  aws ec2 describe-images \
      --filters "Name=name,Values=Centos-7-DevOps-Practice" \
      --output table | grep ImageId | awk '{print $4}'
)

aws ec2 run-instances \
    --image-id "${AMI_ID}" \
    --instance-type t2.micro \
    --count 1 \
    --subnet-id subnet-550b0a18 \
    --security-group-ids sg-0cfbae2747cbac51a \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${NAME}}]" &>>/dev/nul2.0
    echo "Successfully ${NAME} Instance Created"

sleep 15

INSTANCE_ID=$(aws ec2 describe-instances \
    --filters Name=tag:Name,Values="${NAME}" \
    --output table | grep InstanceId | awk '{print $4}')

IPADDRESS=$(aws ec2 describe-instances \
    --instance-ids "${INSTANCE_ID}" \
    --output table | grep PrivateIpAddress | head -n 1 | awk '{print $4}')

sed -e "s/COMPONENT/${NAME}/" -e "s/IPADDRESS/${IPADDRESS}/" record.json >/tmp/record.json

aws route53 change-resource-record-sets \
    --hosted-zone-id Z050212011DFLHIMYY41B \
    --change-batch file:///tmp/record.json