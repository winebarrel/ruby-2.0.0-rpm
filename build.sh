#!/bin/bash
wget -q $VAGRANT_URL
sudo dpkg -i `basename $VAGRANT_URL`
vagrant plugin install vagrant-aws
vagrant box add dummy $DUMMY_BOX_URL

echo "$EC2_PRIVATE_KEY" > $EC2_KEY_NAME
sed -i 's/^export *//' $EC2_KEY_NAME
chmod 600 $EC2_KEY_NAME

wget -O- -q http://s3tools.org/repo/deb-all/stable/s3tools.key | sudo apt-key add -
sudo wget -O/etc/apt/sources.list.d/s3tools.list http://s3tools.org/repo/deb-all/stable/s3tools.list
sudo apt-get update && sudo apt-get install s3cmd

vagrant up --provider=aws 2> /dev/null || echo
vagrant ssh-config > .vagrant.ssh.config
scp -F .vagrant.ssh.config build-rpm.sh ruby200.spec default:~/
vagrant ssh -c '/bin/bash ~/build-rpm.sh'
vagrant destroy
