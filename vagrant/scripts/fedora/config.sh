#!/bin/sh
systemctl set-default graphical.target
systemctl enable gdm.service
sysctl fs.inotify.max_queued_events=1048576
sysctl fs.inotify.max_user_instances=1048576
sysctl fs.inotify.max_user_watches=1048576
sysctl -p