#!/bin/sh
workdir="/home"
kubespray="/home/terraform-ansible-k8s/kubespray"
sudo yum groupinstall -y "Development Tools"

#terraform install
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum -y install terraform
sudo mv /bin/terraform /usr/bin/
terraform init
terraform apply -auto-approve

sudo scp -r  -i  .key_pair/terraform.id_rsa kubespray/ .key_pair/terraform.id_rsa ubuntu@$MASTER1:~/

sudo ssh -i .key_pair/terraform.id_rsa kubespray/ ubuntu@$MASTER1 echo "\$nrconf{kernelhints} = '0';\n\$nrconf{restart} = 'a';" | sudo tee /etc/needrestart/conf.d/50local.conf && sudo apt -y upgrade && sudo apt update && sudo apt install -y python3-pip && export PATH=$PATH:/home/ubuntu/.local/bin && cd kubespray/ && pip install -r requirements.txt && export PATH=$PATH:/home/ubuntu/.local/bin && ansible-playbook -i inventory/inventory -u ubuntu -b -v --private-key=~/terraform.id_rsa cluster.yml


# #pyenv install
# cd $workdir
# sudo yum install -y gcc zlib-devel bzip2 bzip2-devel readline readline-devel sqlite sqlite-devel openssl11 openssl11-devel git libffi-devel xz-devel python-backports-lzma
# git clone https://github.com/pyenv/pyenv.git /home/.pyenv

# echo 'export PATH="/home/.pyenv/bin:$PATH"' >> ~/.bash_profile
# echo 'eval "$(pyenv init -)"' >> ~/.bash_profile
# source ~/.bash_profile

# echo "このインストールは5分くらいかかるので、少し待って"
# pyenv install 3.11.6
# pyenv global 3.11.6
# pyenv rehash

# #pyenv
# python -m venv venv
# source venv/bin/activate

# #ansible 
# cd $kubespray
# ansible-playbook -i inventory/inventory -u ubuntu -b -v --private-key=/home/terraform-ansible-k8s/.key_pair/terraform.id_rsa cluster.yml





#openssl
# if [ ! -d /home/openssl-1.1.1 ]; then

#     cd $workdir
#     sudo wget https://www.openssl.org/source/openssl-1.1.1.tar.gz 
#     sudo tar xvzf openssl-1.1.1.tar.gz
#     cd openssl-1.1.1/
#     sudo ./config --prefix=/usr/local/openssl-1.1.1 shared zlib
#     sudo make depend
#     sudo make
#     sudo make install
#     export LD_LIBRARY_PATH=/usr/local/openssl-1.1.1/lib:$LD_LIBRARY_PATH
#     export CFLAGS="-I/usr/local/openssl-1.1.1/include"
#     sudo ln -s /usr/local/openssl-1.1.1/bin/openssl /usr/local/bin/openssl
# fi

# #python3.10.11
# if [ ! -d /home/Python-3.10.11 ]; then
#     cd $workdir
#     sudo wget https://www.python.org/ftp/python/3.10.11/Python-3.10.11.tgz
#     sudo tar xvf Python-3.10.11.tgz
#     cd Python-3.10.11
#     mkdir build
#     cd build/
#     export LD_LIBRARY_PATH=/usr/local/openssl-1.1.1/lib:$LD_LIBRARY_PATH
#     export CFLAGS="-I/usr/local/openssl-1.1.1/include"
#     ../configure -with-openssl=/usr/local/openssl-1.1.1 --disable-ncurses
#     sudo yum install -y bzip2-devel libbz2-devel libffi-devel
#     make -j
#     sudo ln -s /home/Python-3.10.11/build/python  /usr/local/bin/
#     alias python='/usr/local/bin/python'
#     python -m ensurepip --default-pip
# fi


# #ansible
# cd $workdir
# sudo wget https://github.com/ansible/ansible/archive/refs/tags/v2.15.2.zip
# sudo unzip v2.15.2.zip 
# cd ansible-2.15.2/
# source ./hacking/env-setup
# python -m pip install --upgrade pip
# python -m pip install -r requirements.txt 

