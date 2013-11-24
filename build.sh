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

function install_s3cmd {
  wget -O- -q http://s3tools.org/repo/deb-all/stable/s3tools.key | sudo apt-key add -
  sudo wget -q -O/etc/apt/sources.list.d/s3tools.list http://s3tools.org/repo/deb-all/stable/s3tools.list
  sudo apt-get -q update && sudo apt-get -q install s3cmd
}

function vagrant_up {
  vagrant up --provider=aws 2> /dev/null || true
  vagrant ssh-config > .vagrant.ssh.config
  ssh -t -t -F .vagrant.ssh.config default 'sudo sed -i /requiretty/d /etc/sudoers'
}

function build_rpm {
  scp -F .vagrant.ssh.config build-rpm.sh ruby200.spec default:~/
  vagrant ssh -c '/bin/bash ~/build-rpm.sh'
}

function terminate {
  ssh -t -t -F .vagrant.ssh.config default 'sudo shutdown -h now'
}

install_vagrant
install_ec2_key
vagrant_up
build_rpm
terminate
