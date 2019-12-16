import systemd.daemon
import glob
import os
import re
import subprocess
import sys

BASEDIR = "/usr/local/cluster-prep/"

def log(msg):
    print("[cluster-prep-service]: "+msg)

def determine_hostname(update_hostname=False):
    if 'INSTANCE_ROLE' in os.environ:
        role = os.environ['INSTANCE_ROLE']
    else:
        ip_addr = None
        for device in ["eth0", "ens3", "ens0", "ens1", "ens2"]:
            try:
                ipcmd = subprocess.check_output(["ip", "addr", "show", "dev", device]).decode("utf-8")
            except:
                continue
            print(ipcmd)
            ipcmd = [line.strip().split(" ")[1].split("/")[0] for line in ipcmd.split("\n") if
                     line.strip().startswith("inet ")]
            ip_addr = ipcmd[0]
            break
        if ip_addr is None:
            log("Failed to determine IP address")
            exit(-1)
        log("Determined IP Address: %s" % (ip_addr))
        etchlines = open("/etc/hosts", "r").readlines()
        for line in etchlines:
            parts = re.split(r"\s+", line)
            if parts[0]==ip_addr:
                hostname = parts[1]
                if update_hostname:
                    log("Setting hostname to %s")
                    os.system("hostname %s" % (hostname))
                else:
                    log("Determined real hostname as %s" % (hostname))
                return hostname

def is_locked(lock):
    if os.path.isfile(BASEDIR + "locks/%s.lock" % (lock)):
        return True
    return False

def do_lock(lock, status="locked"):
    os.makedirs(BASEDIR + "locks", exist_ok=True)
    with open(BASEDIR + "locks/%s.lock" % (lock), "w") as fh:
        fh.write(status)

def execute(script):
    log("running " + script)
    if script.endswith(".sh"):
        try:
            subprocess.check_output(["/bin/bash", script])
            log("finished running " + script)
            return "OK"
        except Exception as e:
            log("Failed to run script %s" % (script))
            import traceback
            traceback.print_exc()
            return "Exception: " + str(e)
    elif script.endswith(".py"):
        try:
            subprocess.check_output(["/usr/bin/python3", script])
            log("finished running " + script)
            return "OK"
        except Exception as e:
            log("Failed to run script %s" % (script))
            import traceback
            traceback.print_exc()
            return "Exception: " + str(e)
    else:
        try:
            subprocess.check_output([script])
            log("finished running " + script)
            return "OK"
        except Exception as e:
            log("Failed to run script %s" % (script))
            import traceback
            traceback.print_exc()
            return "Exception: "+str(e)

def main():
    hostname = determine_hostname(True)
    role = hostname
    log("cluster-prep start")
    if role.startswith("node"):
        role = "node"
    log("Determined role: %s" % (role))
    systemd.daemon.notify('READY=1')
    setup_scripts = sorted(glob.glob(BASEDIR + "/setup-scripts/%s/*" % (role)))
    boot_scripts = sorted(glob.glob(BASEDIR + "/setup-scripts/%s/*" % (role)))
    for script in setup_scripts:
        sname = os.path.basename(script)
        if not is_locked(sname):
            log("Executing setup script %s" % (sname))
            do_lock(role + "." + sname, execute(script))
    for script in boot_scripts:
        sname = os.path.basename(script)
        log("Executing on-boot script %s" % (sname))
    do_lock(role+".installation.done", "OK")
    log('cluster-prep startup complete')


if __name__=='__main__':
    main()