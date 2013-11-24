#!/bin/bash
sudo yum install -y rpm-build yum-utils
mkdir -p ~/rpm/{BUILD,SRPMS,SPECS,SOURCES,RPMS}
echo "%_topdir $HOME/rpm" > $HOME/.rpmmacros
mv ~/ruby200.spec ~/rpm/SPECS
echo `hostname`
sudo shutdown -h now
