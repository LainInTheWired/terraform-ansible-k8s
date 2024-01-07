FROM ubuntu:22.04
# terraform
# lsb_releaseがないとapt のsource list で怒られる
RUN apt-get update && apt-get install -y wget gnupg lsb-release vim python3.10-venv
RUN wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list
RUN  apt update -y &&  apt install -y terraform

# ansible
# RUN  apt update
# RUN  apt install -y software-properties-common
# RUN  apt-add-repository --yes --update ppa:ansible/ansible
# RUN  DEBIAN_FRONTEND=noninteractive apt install -y ansible
# ENV VENVDIR=kubespray-venv
# ENV KUBESPRAYDIR=kubespray
# RUN python3 -m venv $VENVDIR
# RUN source $VENVDIR/bin/activate
# WORKDIR $KUBESPRAYDIR
# RUN pip install -U -r requirements.txtVENVDIR=kubespray-venv

