#!/bin/sh
dependencies=$(dnf repoquery --qf "%{name}" $(for dep in $(dnf repoquery --depends vagrant-libvirt 2>/dev/null | cut -d' ' -f1); do echo "--whatprovides ${dep} "; done) 2>/dev/null)
dnf install @virtualization ${dependencies} -y
dnf remove vagrant-libvirt -y
systemctl enable --now libvirtd
usermod -a -G libvirt vagrant
dnf install vagrant -y