# @TODO:
# Write /etc/slurm/gres.conf
# depending on actual resources
# Similar to https://github.com/kadeng/ubuntu-slurm/blob/master/gres.conf.dgx
import glob
import re
import os

def mem_kib_size():
    meminfo = dict((i.split()[0].rstrip(':'), int(i.split()[1])) for i in open('/proc/meminfo').readlines())
    mem_kib = meminfo['MemTotal']  # e.g. 3921852
    return mem_kib

if __name__=='__main__':
    nvidia_devices =  [ os.path.basename(nv) for nv in glob.glob("/dev/nvidia*") if re.match("^nvidia[0-9]+$", os.path.basename(nv))]
    cpu_count = os.cpu_count()
    node_count = 0
    mem_mb = max(int(mem_kib_size()/1024)-100, 1)
    print("CPUs: %d - GPUs: %d" % (cpu_count, len(nvidia_devices)))
    if len(nvidia_devices)>0:
        with open("/etc/slurm/slurm.conf", "a") as fh:
            fh.write("NodeName=node[0-230] Gres=gpu:%d RealMemory=%d CPUs=%d State=UNKNOWN\n" % (len(nvidia_devices), mem_mb, cpu_count))
