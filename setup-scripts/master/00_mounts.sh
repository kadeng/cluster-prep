#!/bin/bash
# This is neccessary since, on nitro based instances, automountint these does not seem to work
mount /data
mkdir -p /data/nfs
chmod 777 /data/nfs
mount /data/nfs
