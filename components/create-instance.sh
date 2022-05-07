#!/usr/bin/env bash
#aws ec2 run-instances --image-id ami-0bb6af715826253bf --instance-type t2.micro
#aws ec2 describe-images --filters "Name=Name:Type,Values=Centos-7-DevOps-Practice" --output text

#aws ec2 describe-images \
   # --filters "Name=Name:Type,Values=Centos-7-DevOps-Practice" \
   # --output text

aws ec2 run-instances \
    --image-id ami-0bb6af715826253bf \
    --instance-type t2.micro \
    --count 1 \
    --subnet-id subnet-550b0a18 \
    --security-group-ids sg-0cfbae2747cbac51a \
    --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=}]'

