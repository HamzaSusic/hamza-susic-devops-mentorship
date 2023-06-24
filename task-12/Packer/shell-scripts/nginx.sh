#/bin/bash

echo "This is script to enable nginx  yum repos"
sleep 30
sudo yum update -y
sudo yum install -y yum-utils