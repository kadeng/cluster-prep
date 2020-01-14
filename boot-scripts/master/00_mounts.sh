#!/bin/bash
mount /data
mount /data/nfs
exportfs -a
systemctl restart nfs-kernel-server

