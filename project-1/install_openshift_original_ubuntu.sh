#!/bin/bash

#1. Install Docker

sudo apt-get update

sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo apt-key fingerprint 0EBFCD88

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

sudo usermod -aG docker $USER

#2. Install openshift origin client tool

sudo wget https://github.com/openshift/origin/releases/download/v3.11.0/openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz
sudo tar -xvzf openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz
cd openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit/
sudo mv oc kubectl /usr/local/bin/

# 3. Login as root

#sudo su -

#cat << EOF > /etc/docker/daemon.json
##{
#    "insecure-registries" : [ "172.30.0.0/16" ]
#}
#EOF

#exit

#sudo systemctl restart docker

#sudo mkdir /etc/containers

#sudo touch /etc/containers/registries.conf

#sudo bash -c 'echo "$(cat <<EOF [registries.search] 
#                registries = ["registry.access.redhat.com", "registry.redhat.io", "docker.io", "quay.io"] 
#                [registries.insecure] 
#                registries = ["registry.access.redhat.com", "registry.redhat.io", "docker.io", "quay.io"]
#                EOF)" > /etc/containers/registries.conf'

#sudo hostnamectl set-hostname ec2-16-171-66-253.eu-north-1.compute.amazonaws.com

#sudo oc cluster up --public-hostname=ec2-16-171-66-253.eu-north-1.compute.amazonaws.com

#sudo oc cluster up --routing-suffix=compute.amazonaws.com --public-hostname=ec2-16-171-66-253.eu-north-1.compute.amazonaws.com