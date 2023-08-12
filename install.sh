#!/bin/sh

sudo yum groupinstall "Development Tools"

#terraform install
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum -y install terraform
sudo mv /bin/terraform /usr/bin/

#openssl
cd ~/
cd ../
sudo curl https://www.openssl.org/source/openssl-1.1.1.tar.gz 
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
../configure --enable-optimization
export LD_LIBRARY_PATH=/usr/local/openssl-1.1.1/lib:$LD_LIBRARY_PATH
export CFLAGS="-I/usr/local/openssl-1.1.1/include"
make -j
