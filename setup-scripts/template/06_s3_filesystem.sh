#!/bin/bash
pip3 install yas3fs==2.3.5
sed -i'' 's/^# *user_allow_other/user_allow_other/' /etc/fuse.conf
chmod a+r /etc/fuse.conf


