#!/bin/bash
wget -q $VAGRANT_URL
sudo dpkg -i `basename $VAGRANT_URL`
vagrant plugin install vagrant-aws
vagrant box add dummy $DUMMY_BOX_URL
echo "$EC2_PRIVATE_KEY" > $EC2_KEY_NAME
sed -i 's/^export *//' $EC2_KEY_NAME
chmod 600 $EC2_KEY_NAME
vagrant up --provider=aws || echo
