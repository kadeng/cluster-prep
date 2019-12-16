# cluster-prep

This is a collection of scripts to set up and prepare various software packages
on a HPC cluster automatically.


### Installation

This script has been tested with Ubuntu 18.04 but should also work with other Ubuntu/Linux variants
which use systemd for startup scripts.

**Install dependencies**

    apt-get install wget git python3-pip python3-systemd 

**Install Cluster-Prep Scripts**

Make sure this project (or a variant) is copied to "/usr/local/cluster-prep". For example by executing 
    sudo git clone https://github.com/kadeng/cluster-prep /usr/local/cluster-prep
   
Copy the systemd service config, then enable and start the service 
    sudo cp /usr/local/cluster-prep/etc/systemd/system/clusterprep.service /etc/systemd/system/clusterprep.service
    systemctl enable clusterprep
    systemctl start clusterprep

### Server Role

The current server role is determined like this: First, the IP address is determined
by executing "ip addr show <device>" for the devices etho0, ens3, ens2,
ens1 and ens0 (in that order). First viable IPv4 address is taken.

Next, we look up the first hostname in /etc/hosts for that IP address.
If that hostname starts with "node" (e.g. it might be "node_01", 
then the role is "node". Otherwise, the role is the hostname.

### Scripts & structure

This script implements a systemd service, which 
executes scripts according to the automatically determined 
server role (see above):

 * Scripts within setup-scripts/[role-name] are executed once. Completion is marked via lockfiles in /usr/local/cluster-prep/locks/
 * Scripts within boot-scripts/[role-name] are executed on every boot.
 
 The script executes the scripts it finds in lexicographic order. All setup scripts are run before boot scripts.
 
 Scripts ending with ".sh" are executed as bash scripts with root rights.
 Scripts ending with ".py" are executed as python3 scripts with root rights, using the /usr/bin/python3
 python executable (which is what the python3 apt package provides)
 
### Pre-Made scripts

 * **name_hosts** - A script which fill /etc/hosts with names node0-node220 for the IP range 10.23.23.10+i where is is the node index.
 * **s3_filesystem** - Installs yas3fs, a fuse-based S3 filesystem
 * **anaconda python** Install anaconda python for the ubuntu user, within /home/ubuntu/anaconda3 - additional installation 
                       of pytorch, pytorch-lighting and ptpython ( see https://github.com/prompt-toolkit/ptpython )
 * **slurm** installs Slurm cluster manager. See [Slurm on Ubuntu](https://github.com/kadeng/ubuntu-slurm), 
             [Slurm Docs](https://slurm.schedmd.com/) and [Pytorch Lightning for parallel training on Slurm](https://williamfalcon.github.io/pytorch-lightning/Trainer/SLURM%20Managed%20Cluster/)


## Usage

The clusterprep service can be started, stopped and monitored like any other
systemd service.

Please note that the *scripts have not finished running* when systemctl start clusterprep returns.

If you want to delay some action until the installation finished, wait until the file
*/usr/local/cluster-prep/locks/[role-name].installation.done.lock* exists.

