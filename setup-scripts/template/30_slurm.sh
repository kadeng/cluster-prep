#!/bin/bash
# Following https://github.com/mknoxnv/ubuntu-slurm
apt-get -y install git gcc make ruby ruby-dev libpam0g-dev libmariadb-client-lgpl-dev libmysqlclient-dev libmunge-dev libmunge2 munge mariadb-server
gem install fpm
systemctl enable mysql
systemctl start mysql
cat /usr/local/cluster-prep/resources/slurm_create_db.mysql.txt | mysql -u root
systemctl disable mysql
systemctl disable munge
systemctl stop munge
systemctl stop mysql
cd /usr/local/cluster-prep/downloads
wget https://download.schedmd.com/slurm/slurm-19.05.4.tar.bz2
tar -xvvjf slurm-19.05.4.tar.bz2 slurm-19.05.4
cd slurm-19.05.4
./configure --prefix=/tmp/slurm-build --sysconfdir=/etc/slurm --enable-pam --with-pam_dir=/lib/x86_64-linux-gnu/security/ --without-shared-libslurm
make
make contrib
make install
cd /usr/local/cluster-prep/downloads
fpm -s dir -t deb -v 1.0 -n slurm-19.05.4 --prefix=/usr/ -C /tmp/slurm-build .
dpkg -i slurm-19.05.4_1.0_amd64.deb
mkdir -p /etc/slurm /etc/slurm/prolog.d /etc/slurm/epilog.d /var/spool/slurm/ctld /var/spool/slurm/d /var/log/slurm
chown ubuntu /var/spool/slurm/ctld /var/spool/slurm/d /var/log/slurm
cd /usr/local
git clone https://github.com/kadeng/ubuntu-slurm
mkdir -p /etc/slurm
cd /usr/local/ubuntu-slurm
cp *.service /etc/systemd/system
cp slurm.conf /etc/slurm/
cp slurmdbd.conf /etc/slurm/
cp gres.conf /etc/slurm/gres.conf
cp cgroup.conf /etc/slurm/cgroup.conf
cp cgroup_allowed_devices_file.conf /etc/slurm/cgroup_allowed_devices_file.conf
systemctl daemon-reload
systemctl disable slurmdbd
systemctl disable slurmctld
