#!/bin/bash

cd /chroot

umount ./debian_gaming/run/user/1000 ./debian_gaming/* 

rm -rf debian_gaming

rm -rf /etc/binfmt.d/box*

systemctl restart systemd-binfmt

pacman -R debootstrap debian-archive-keyring xorg-xhost


