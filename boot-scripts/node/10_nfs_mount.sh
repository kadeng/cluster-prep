#!/bin/bash
echo "Attemping to mount /nfs from master at mountpoint /nfs"
mkdir -p /data/nfs
chmod 777 /data/nfs
mount 10.23.23.10:/data/nfs /data/nfs
