#!/usr/bin/env bash

if [ -z "$1" ]; then
  echo "Instance argument required"
  exit 1
fi

if [ "$1" == "list" ]; then
  aws ec2 describe-instances  \
    --query "Reservations[*].Instances[*].
    {PrivateIP:PrivateIpAddress,PublicIP:PublicIpAddress,Name:Tags[?Key=='Name']|[0].Value,Status:State.Name}"  \
    --output table
  exit 0
fi

NAME=$1

aws ec2 describe-spot-instance-requests \
    --filters Name=tag:Name,Values="${NAME}" Name=state,Values=active \
    --output table | grep InstanceId &>>/dev/null

if [ $? -eq 0 ]; then
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
      --tag-specifications "ResourceType=spot-instances-request,Tags=[{Key=Name,Value=${NAME}}]" "ResourceType=instance,Tags=[{Key=Name,Value=${NAME}}]" &>>/dev/null
      echo "Successfully ${NAME} Instance Created"

sleep 10

INSTANCE_ID=$(aws ec2 describe-instances \
      --filters Name=tag:Name,Values="${NAME}" \
      --output table | grep InstanceId | awk '{print $4}')

IPADDRESS=$(aws ec2 describe-instances \
      --instance-ids "${INSTANCE_ID}" \
      --output table | grep PrivateIpAddress | head -n 1 | awk '{print $4}')

sed -e "s/COMPONENT/${NAME}/" -e "s/IPADDRESS/${IPADDRESS}/" record.json >/tmp/record.json

aws route53 change-resource-record-sets \
    --hosted-zone-id Z050212011DFLHIMYY41B \
    --change-batch file:///tmp/record.json &>>/dev/null
echo "DNS Record Created"