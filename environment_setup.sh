#!bin/bash
#setup for cloud9 Rehhat environment
cd /etc/yum.repos.d/
sudo wget http://download.opensuse.org/repositories/shells:fish:release:3/RHEL_7/shells:fish:release:3.repo
sudo yum install -y fish 
sudo yum install -y https://releases.hashicorp.com/vagrant/2.2.4/vagrant_2.2.4_x86_64.rpm
sudo yum install epel-release

git clone https://github.com/hung135/aurora
export keypair_name=$HOSTNAME
aws --region us-east-1 ec2 delete-key-pair --key-name $keypair_name
aws --region us-east-1 ec2 create-key-pair --key-name "$keypair_name" --output text > ~/.ssh/$keypair_name.pem
chmod 400 ~/.ssh/$keypair_name.pem