#!/bin/sh

sudo yum groupinstall -y "Development Tools"

#terraform install
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum -y install terraform
sudo mv /bin/terraform /usr/bin/

#openssl
cd ~/
cd ../
sudo wget https://www.openssl.org/source/openssl-1.1.1.tar.gz 
sudo tar xvzf openssl-1.1.1.tar.gz
cd openssl-1.1.1/
sudo ./config --prefix=/usr/local/openssl-1.1.1 shared zlib
sudo make depend
sudo make
sudo make install
ln -s /usr/local/openssl-1.1.1/bin/openssl /usr/local/openssl

#python3.10.11
cd ~/
cd ../
sudo wget https://www.python.org/ftp/python/3.10.11/Python-3.10.11.tgz
sudo tar xvf Python-3.10.11.tgz
cd Python-3.10.11
mkdir build
cd build/
../configure -with-openssl=/usr/local/openssl-1.1.1 --disable-ncurses
export LD_LIBRARY_PATH=/usr/local/openssl-1.1.1/lib:$LD_LIBRARY_PATH
export CFLAGS="-I/usr/local/openssl-1.1.1/include"
sudo yum install -y bzip2-devel libbz2-devel libffi-devel
make -j
sudo ln -s /home/Python-3.10.11/build/python  /usr/local/bin/
alias python='/usr/local/bin/python'


#ansible
sudo wget https://github.com/ansible/ansible/archive/refs/tags/v2.15.2.zip
sudo unzip v2.15.2.zip 
cd ansible-2.15.2/
source ./hacking/env-setup
python -m pip install --upgrade pip
python -m pip install -r requirements.txt 

