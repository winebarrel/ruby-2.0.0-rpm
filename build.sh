#!/bin/bash
function install_vagrant {
  wget -q $VAGRANT_URL
  sudo dpkg -i `basename $VAGRANT_URL`
  vagrant plugin install vagrant-aws
  vagrant box add dummy $DUMMY_BOX_URL
}

function install_ec2_key {
  echo "$EC2_PRIVATE_KEY" > $EC2_KEY_NAME
  sed -i 's/^export *//' $EC2_KEY_NAME
  chmod 600 $EC2_KEY_NAME
}

function update_s3cfg {
  sed -i "s/^access_key = */access_key = $AWS_ACCESS_KEY_ID/" .s3cfg
  sed -i "s/^secret_key = */secret_key = $AWS_SECRET_ACCESS_KEY/" .s3cfg
  sed -i "s/S3_BUCKET/$S3_BUCKET/" build-rpm.sh
}

function vagrant_up {
  vagrant up --provider=aws 2> /dev/null || true
  vagrant ssh-config > .vagrant.ssh.config
  ssh -t -t -F .vagrant.ssh.config default 'sudo sed -i /requiretty/d /etc/sudoers'
}

function build_rpm {
  scp -F .vagrant.ssh.config build-rpm.sh ruby200.spec .s3cfg default:~/
  vagrant ssh -c '/bin/bash ~/build-rpm.sh'
}

install_vagrant
install_ec2_key
vagrant_up
update_s3cfg
build_rpm
