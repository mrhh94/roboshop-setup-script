#aws ec2 run-instances --image-id ami-0bb6af715826253bf --instance-type t2.micro

aws ec2 run-instances \
    --image-id ami-0bb6af715826253bf \
    --instance-type t2.micro \
    --count 5 \
    --subnet-id subnet-550b0a18 \
    --security-group-ids sg-0cfbae2747cbac51a \
    --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=Test 911}]'