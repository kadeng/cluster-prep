#!/bin/bash
# Following https://github.com/mknoxnv/ubuntu-slurm
systemctl enable munge
systemctl start munge
sleep 5
systemctl start slurmd
