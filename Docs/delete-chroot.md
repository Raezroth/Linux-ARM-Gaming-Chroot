## Uninstalling the chroot

--------

If using `systemd-nspawn`, exit the container then delete chroot folder. Make sure it's closed and not mounted. `systemd-nspawn` should automatically umount.

To delete container, do:

```
sudo rm -r PATH-TO-CHROOT/gaming
``` 

-----

If using the `chroot` command, navigate to chroot directoy, Example: mine is /home/alarm/chroot/gaming

Inside the chroot folder umount /dev, /proc, & /sys

`sudo umount ./*`  This is if you are inside /home/$USER/chroot/gaming directory

`sudo umount gaming/*`  If you are in the folder /home/$USER/chroot 

Then run ]`sudo rm -r PATH-TO-CHROOT/gaming/`

------

Removing debootstrap and xhost

For Arch-based Distro(Arch Linux, Manjaro): `sudo pacman -R debootstrap debian-archive-keyring xorg-xhost`

For Debian-based Distro(Mobian, Ubuntu Touch??): `sudo apt remove debootstrap debian-archive-keyring x11-xserver-utils`

---------

[< Tips and Tricks](tips.md) | [Credits >](credits.md)


