#!/bin/bash
# This does not work with pip3, there is some python3 incompatibility
pip install yas3fs==2.3.5
sed -i'' 's/^# *user_allow_other/user_allow_other/' /etc/fuse.conf
chmod a+r /etc/fuse.conf
