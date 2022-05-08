#!/usr/bin/env bash

if [ -z "$1" ]; then
  echo "Instance argument required"
  exit 1
fi

NAME=$1

aws ec2 describe-spot-instance-requests \
    --filters Name=tag:Name,Values="${NAME}" Name=state,Values=active \
    --output table | grep InstanceId | awk '{print $5}' &>/dev/null

if [ "$1" -eq 0 ]; then
  echo "Instance Already Exists"
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
      --count 1 --subnet-id subnet-550b0a18 \
      --security-group-ids sg-0cfbae2747cbac51a \
      --instance-market-options "MarketType=spot,SpotOptions={SpotInstanceType=persistent,InstanceInterruptionBehavior=stop}" \
      --tag-specifications "ResourceType=spot-instances-request,Tags=[{Key=Name,Value=${NAME}}]" "ResourceType=instance,Tags=[{Key=Name,Value=${NAME}}]"
