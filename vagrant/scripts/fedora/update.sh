#!/bin/sh
dnf update -y
dnf install podman -y
dnf install telnet -y
dnf install terminator -y
dnf install zsh -y
dnf install helm -y
dnf install kubectl -y
dnf groupinstall "Pantheon Desktop" --skip-broken  -y 
dnf groupinstall "Fedora Workstation" --skip-broken -y
dnf groupinstall "Development Tools"  --skip-broken -y