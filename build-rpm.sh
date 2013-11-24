#!/bin/bash
chmod 600 ~/.s3cfg
wget -q http://ftp.riken.jp/Linux/fedora/epel/6/i386/epel-release-6-8.noarch.rpm
rpm -ivh epel-release-6-8.noarch.rpm
sudo yum install -y rpm-build readline readline-devel ncurses ncurses-devel gdbm gdbm-devel glibc-devel tcl-devel gcc unzip openssl-devel db4-devel byacc make libyaml libyaml-devel libffi libffi-devel
sudo yum install -y --enablerepo=epel s3cmd
mkdir -p ~/rpm/{BUILD,SRPMS,SPECS,SOURCES,RPMS}
echo "%_topdir $HOME/rpm" > $HOME/.rpmmacros
mv ~/ruby200.spec ~/rpm/SPECS
cd rpm
wget -q -O ./SOURCES/ruby-2.0.0-p353.tar.gz http://cache.ruby-lang.org/pub/ruby/2.0/ruby-2.0.0-p353.tar.gz
rpmbuild -ba ./SPECS/ruby200.spec
s3cmd -c ~/.s3cfg put --acl-public --force ~/rpm/RPMS/x86_64/*.rpm s3://S3_BUCKET/
s3cmd -c ~/.s3cfg put --acl-public --force ~/rpm/SRPMS/*.rpm s3://S3_BUCKET/
sudo shutdown -h now
