#!/bin/bash
# Disable all those services which cannot operate in the sandbox anyway
systemctl stop amazon-ssm-agent
systemctl disable amazon-ssm-agent
systemctl stop dbus-org.freedesktop.resolve1
systemctl disable dbus-org.freedesktop.resolve1
systemctl stop snap.amazon-ssm-agent.amazon-ssm-agent
systemctl disable snap.amazon-ssm-agent.amazon-ssm-agent
