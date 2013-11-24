#!/bin/bash
wget -q $VAGRANT_URL
sudo dpkg -i `basename $VAGRANT_URL`
vagrant plugin install vagrant-aws
vagrant box add dummy $DUMMY_BOX_URL
echo "$EC2_PRIVATE_KEY" > $EC2_KEY_NAME
sed -i 's/^export *//' $EC2_KEY_NAME
chmod 600 $EC2_KEY_NAME
vagrant up --provider=aws 2> /dev/null || echo
vagrant ssh-config > .vagrant.ssh.config
scp -F .vagrant.ssh.config build-rpm.sh default:~/
vagrant ssh -c bash ~/build-rpm.sh
vagrant destroy
