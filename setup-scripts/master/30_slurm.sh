#!/bin/bash
# Following https://github.com/mknoxnv/ubuntu-slurm
systemctl enable munge
systemctl start munge
systemctl enable mysql
systemctl start mysql
