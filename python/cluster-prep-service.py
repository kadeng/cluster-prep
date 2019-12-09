import systemd.daemon
import glob
import os
import re
import subprocess
import sys
BASEDIR = "/usr/local/cluster-prep/"
def determine_hostname(update_hostname=False):
    if 'INSTANCE_ROLE' in os.environ:
        role = os.environ['INSTANCE_ROLE']
    else:
        try:
            ipcmd = subprocess.check_output(["ip", "addr", "show", "dev", "eth0"]).decode("utf-8")
            print(ipcmd)
            ipcmd = [ line.strip().split(" ")[1].split("/")[0] for line in ipcmd.split("\n") if line.strip().startswith("inet ")]
            ip_addr = ipcmd[0]
        except:
            import traceback
            traceback.print_exc()
            print("Failed to determine IP address for eth0 - could not parse output", file=sys.stderr)
            exit(-22)
        print("Determined IP Address: %s" % (ip_addr))
        etchlines = open("/etc/hosts", "r").readlines()
        for line in etchlines:
            parts = re.split(r"\s+", line)
            if parts[0]==ip_addr:
                hostname = parts[1]
                if update_hostname:
                    print("Setting hostname to %s")
                    os.system("hostname %s" % (hostname))
                else:
                    print("Determined real hostname as %s" % (hostname))
                return hostname

def is_locked(lock):
    if os.path.isfile(BASEDIR + "locks/%s.lock" % (lock)):
        return True
    return False

def do_lock(lock, status="locked"):
    with open(BASEDIR + "locks/%s.lock" % (lock), "w") as fh:
        fh.write(status)

def execute(script):
    if script.endswith(".sh"):
        try:
            subprocess.check_output(["/bin/bash", script])
            return "OK"
        except Exception as e:
            return str(e)
            import traceback
            traceback.print_exc()
            return "Exception: " + str(e)
    elif script.endswith(".py"):
        try:
            subprocess.check_output(["/usr/bin/python3", script])
            return "OK"
        except Exception as e:
            return str(e)
            import traceback
            traceback.print_exc()
            return "Exception: " + str(e)
    else:
        try:
            subprocess.check_output([script])
            return "OK"
        except Exception as e:
            print("Failed to run script %s" % (script))
            import traceback
            traceback.print_exc()
            return "Exception: "+str(e)

def main():
    hostname = determine_hostname()
    role = hostname
    print("cluster-prep startup")
    if role.startswith("node"):
        role = "node"
    print("Current role: %s" % (role))
    setup_scripts = glob.glob(BASEDIR + "/setup-scripts/%s/*")
    boot_scripts = glob.glob(BASEDIR + "/setup-scripts/%s/*")
    for script in setup_scripts:
        sname = os.path.basename(script)
        if not is_locked(sname):
            print("Executing setup script %s" % (sname))
            do_lock(sname, execute(script))
    for script in boot_scripts:
        sname = os.path.basename(script)
        print("Executing on-boot script %s" % (sname))

    print('cluster-prep startup complete')
    systemd.daemon.notify('READY=1')

if __name__=='__main__':
    main()