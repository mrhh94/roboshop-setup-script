#!/usr/bin/env bash

if [ -z "$1" ]; then
  echo "Instance argument required"
  exit 1
fi

NAME=$1

#aws ec2 describe-instances --filters "Name=tag:Name,Values=frontend Name=state,Values=active"

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
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${NAME}}]"



