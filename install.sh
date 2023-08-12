#!/bin/sh
workdir="/home"
sudo yum groupinstall -y "Development Tools"

#terraform install
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum -y install terraform
sudo mv /bin/terraform /usr/bin/

#openssl
if [ ! -d /home/openssl-1.1.1 ]; then

    cd $workdir
    sudo wget https://www.openssl.org/source/openssl-1.1.1.tar.gz 
    sudo tar xvzf openssl-1.1.1.tar.gz
    cd openssl-1.1.1/
    sudo ./config --prefix=/usr/local/openssl-1.1.1 shared zlib
    sudo make depend
    sudo make
    sudo make install
    export LD_LIBRARY_PATH=/usr/local/openssl-1.1.1/lib:$LD_LIBRARY_PATH
    export CFLAGS="-I/usr/local/openssl-1.1.1/include"
    sudo ln -s /usr/local/openssl-1.1.1/bin/openssl /usr/local/bin/openssl
fi

#python3.10.11
if [ ! -d /home/Python-3.10.11 ]; then
    cd $workdir
    sudo wget https://www.python.org/ftp/python/3.10.11/Python-3.10.11.tgz
    sudo tar xvf Python-3.10.11.tgz
    cd Python-3.10.11
    mkdir build
    cd build/
    export LD_LIBRARY_PATH=/usr/local/openssl-1.1.1/lib:$LD_LIBRARY_PATH
    export CFLAGS="-I/usr/local/openssl-1.1.1/include"
    ../configure -with-openssl=/usr/local/openssl-1.1.1 --disable-ncurses
    sudo yum install -y bzip2-devel libbz2-devel libffi-devel
    make -j
    sudo ln -s /home/Python-3.10.11/build/python  /usr/local/bin/
    alias python='/usr/local/bin/python'
    python -m ensurepip --default-pip
fi


#ansible
cd $workdir
sudo wget https://github.com/ansible/ansible/archive/refs/tags/v2.15.2.zip
sudo unzip v2.15.2.zip 
cd ansible-2.15.2/
source ./hacking/env-setup
python -m pip install --upgrade pip
python -m pip install -r requirements.txt 

