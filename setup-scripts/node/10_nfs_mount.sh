#!/bin/bash
echo "Attemping to mount /nfs from master at mountpoint /nfs"
sleep 5
mkdir -p /nfs
chmod 777 /nfs
mount 10.23.23.10:/nfs /nfs
