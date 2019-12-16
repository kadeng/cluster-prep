#!/bin/bash
# Disable all those services which cannot operate in the sandbox anyway
systemctl stop amazon-ssm-agent
systemctl disable amazon-ssm-agent
systemctl systemctl stop systemd-resolved
systemctl systemctl disable systemd-resolved
systemctl stop dbus-org.freedesktop.resolve1
systemctl disable dbus-org.freedesktop.resolve1
systemctl stop snap.amazon-ssm-agent.amazon-ssm-agent
systemctl disable snap.amazon-ssm-agent.amazon-ssm-agent
echo "StrictHostKeyChecking no" >>/etc/ssh/ssh_config