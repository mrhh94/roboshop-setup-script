#!/usr/bin/env bash

NAME=$1

aws ec2 run-instances \
      --image-id ami-0bb6af715826253bf \
      --instance-type t2.micro \
      --count 1 --subnet-id subnet-550b0a18 \
      --security-group-ids sg-0cfbae2747cbac51a \
      --instance-market-options "MarketType=spot,SpotOptions={SpotInstanceType=persistent,InstanceInterruptionBehavior=stop}" \
      --tag-specifications "ResourceType=spot-instances-request,Tags=[{Key=Name,Value=${NAME}}]" "ResourceType=instance,Tags=[{Key=Name,Value=${NAME}}]"
