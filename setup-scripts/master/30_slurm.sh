#!/bin/bash
# Following https://github.com/mknoxnv/ubuntu-slurm

systemctl enable munge
systemctl start munge
systemctl enable mysql
systemctl start mysql

systemctl daemon-reload
systemctl enable slurmdbd
systemctl start slurmdbd
systemctl enable slurmctld
systemctl start slurmctld

sacctmgr -i add cluster compute-cluster
sacctmgr -i add account compute-account description="Compute accounts" Organization=OurOrg
sacctmgr -i create user ubuntu account=compute-account adminlevel=None
sinfo
