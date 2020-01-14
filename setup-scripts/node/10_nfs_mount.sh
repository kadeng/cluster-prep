#!/bin/bash
echo "Attemping to mount /data/nfs from master at mountpoint /data/nfs"
sleep 3
mkdir -p /data/nfs
chmod 777 /data/nfs
mount 10.23.23.10:/data/nfs /data/nfs
