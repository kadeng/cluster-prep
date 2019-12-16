#!/bin/bash
cd /usr/local/cluster-prep/downloads
chmod -R +X /usr/local/cluster-prep # Ensure we can enter directories as ubuntu user
wget https://repo.anaconda.com/archive/Anaconda3-2019.10-Linux-x86_64.sh
chmod +x Anaconda3-2019.10-Linux-x86_64.sh
sudo -i -u ubuntu /usr/local/cluster-prep/downloads/Anaconda3-2019.10-Linux-x86_64.sh -b -p /home/ubuntu/anaconda3
echo "source /usr/local/cluster-prep/resources/anaconda_bashrc_hook.sh" >>/home/ubuntu/.bashrc
sudo -i -u ubuntu /home/ubuntu/anaconda3/bin/conda install pytorch torchvision cudatoolkit=10.1 -c pytorch
sudo -i -u ubuntu /home/ubuntu/anaconda3/bin/pip install ptpython ipython awscli pytorch-lightning test-tube
sudo -i -u ubuntu /home/ubuntu/anaconda3/bin/conda install opencv fasttext dask-jobqueue -c conda-forge
