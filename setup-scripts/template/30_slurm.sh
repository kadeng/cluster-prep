#!/bin/bash
# Following https://github.com/mknoxnv/ubuntu-slurm
apt-get -y install git gcc make ruby ruby-dev libpam0g-dev libmariadb-client-lgpl-dev libmysqlclient-dev libmunge-dev libmunge2 munge mariadb-server
gem install fpm
systemctl disable mysql
systemctl disable munge
cd /usr/local/cluster-prep/downloads
wget https://download.schedmd.com/slurm/slurm-19.05.4.tar.bz2
tar -xvvjf slurm-19.05.4.tar.bz2 slurm-19.05.4
cd slurm-19.05.4
./configure --prefix=/tmp/slurm-build --sysconfdir=/etc/slurm --enable-pam --with-pam_dir=/lib/x86_64-linux-gnu/security/ --without-shared-libslurm
make
make contrib
make install
cd /usr/local/cluster-prep/downloads
#fpm -s dir -t deb -v 1.0 -n slurm-19.05.4 --prefix=/usr/ -C /tmp/slurm-build .
#dpkg -i slurm-19.05.4_1.0_amd64.deb
#useradd slurm
#mkdir -p /etc/slurm /etc/slurm/prolog.d /etc/slurm/epilog.d /var/spool/slurm/ctld /var/spool/slurm/d /var/log/slurm
#chown slurm /var/spool/slurm/ctld /var/spool/slurm/d /var/log/slurm