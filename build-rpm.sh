#!/bin/bash
sudo yum install -y rpm-build readline readline-devel ncurses ncurses-devel gdbm gdbm-devel glibc-devel tcl-devel gcc unzip openssl-devel db4-devel byacc make libyaml libyaml-devel libffi libffi-devel
mkdir -p ~/rpm/{BUILD,SRPMS,SPECS,SOURCES,RPMS}
echo "%_topdir $HOME/rpm" > $HOME/.rpmmacros
mv ~/ruby200.spec ~/rpm/SPECS
cd rpm
wget -q -O ./SOURCES/ruby-2.0.0-p353.tar.gz http://cache.ruby-lang.org/pub/ruby/2.0/ruby-2.0.0-p353.tar.gz
rpmbuild -ba ./SPECS/ruby200.spec
