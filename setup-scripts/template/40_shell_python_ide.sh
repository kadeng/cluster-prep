#!/bin/bash
# Install prerequisites ( some might already exist)
apt-get -y install ranger tmux
sudo -i -u ubuntu /home/ubuntu/anaconda3/bin/pip install ptpython==2.0.6 ipython

# Configure ptpython / ptipython
sudo -i -u ubuntu mkdir -p /home/ubuntu/.ptpython
cp /usr/local/cluster-prep/resources/ptpython_config.py /home/ubuntu/.ptpython/config.py
chown ubuntu:ubuntu /home/ubuntu/.ptpython/config.py

# Install pide script, which is a nice script to manage tmux sessions
# with ptipython, ranger and bash
# Using TMUX customizations from https://www.hamvocke.com/blog/a-guide-to-customizing-your-tmux-conf/
cp /usr/local/cluster-prep/resources/pide.sh /usr/local/bin/pide
chmod +x /usr/local/bin/pide

cp /usr/local/cluster-prep/resources/pyde.sh /usr/local/bin/pyde
chmod +x /usr/local/bin/pyde
