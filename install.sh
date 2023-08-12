#!/bin

sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum -y install terraform
sudo mkdir /home/app
sudo mkdir /home/app
sudo mv /bin/terraform /home/app/
export PATH="$PATH:/home/app/"


