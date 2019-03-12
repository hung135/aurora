#!bin/bash
#setup for cloud9 Rehhat environment
cd /etc/yum.repos.d/
sudo wget http://download.opensuse.org/repositories/shells:fish:release:3/RHEL_7/shells:fish:release:3.repo
sudo yum install -y fish 
sudo yum install -y https://releases.hashicorp.com/vagrant/2.2.4/vagrant_2.2.4_x86_64.rpm
sudo yum install -y ansible 

git clone https://github.com/hung135/aurora
export key_pair_name=$HOSTNAME-$C9_USER
chmod 600 ~/.ssh/$key_pair_name.pem
chmod 600 ~/.ssh/$key_pair_name.pem_bk
aws --region us-east-1 ec2 delete-key-pair --key-name $key_pair_name
aws --region us-east-1 ec2 create-key-pair --key-name "$key_pair_name" --output text > ~/.ssh/$key_pair_name.pem
cp ~/.ssh/$key_pair_name.pem ~/.ssh/$key_pair_name.pem_bk
sed -i 's/^.*-----BEGIN/-----BEGIN/' ~/.ssh/$key_pair_name.pem
sed -i 's/^-----END RSA PRIVATE KEY-----.*$/-----END RSA PRIVATE KEY-----/' ~/.ssh/$key_pair_name.pem
chmod 400 ~/.ssh/$key_pair_name.pem 
 
vagrant box add aws_dummy https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box
vagrant plugin install vagrant-aws
vagrant plugin install vagrant-vbguest 
echo abc >deploy/.vault.password
echo 'export key_pair_name=$HOSTNAME-$C9_USER' >>~/.bash_profile
git config credential.helper store

#echo 'export key_pair_name=$HOSTNAME' >> ~/.bash_profile