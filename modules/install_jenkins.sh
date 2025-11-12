#!/bin/bash


function jenkins_setup {

    sudo yum update -y
    sudo yum install java-17 -y

    sudo wget -O /etc/yum.repos.d/jenkins.repo \
        https://pkg.jenkins.io/redhat-stable/jenkins.repo

    sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

    sudo yum clean all
    sudo yum makecache
    sudo yum install jenkins -y

    sudo systemctl enable jenkins
    sudo systemctl start jenkins
    sudo systemctl status jenkins

    echo "Jenkins is installed!"
}


function ansible_setup {

    sudo yum install -y python3
    sudo python3 -m ensurepip --upgrade
    sudo pip3 install ansible

    echo 'export PATH=$HOME/.local/bin:$PATH' >> ~/.bashrc
    source ~/.bashrc

    echo "Ansible is installed!"
}


function terraform_setup {
    sudo yum install -y yum-utils
    sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
    sudo yum -y install terraform
}



function terragrunt_setup {
    sudo yum install -y wget unzip
    TERRAGRUNT_VERSION=$(curl -s https://api.github.com/repos/gruntwork-io/terragrunt/releases/latest | grep tag_name | cut -d '"' -f 4)
    wget https://github.com/gruntwork-io/terragrunt/releases/download/${TERRAGRUNT_VERSION}/terragrunt_linux_amd64 -O terragrunt

    sudo mv terragrunt /usr/local/bin/
    sudo chmod +x /usr/local/bin/terragrunt
}



function aws_setup {
    sudo yum install -y unzip curl
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
}


function main {
    jenkins_setup
    ansible_setup
    terraform_setup
    terragrunt_setup
}

main