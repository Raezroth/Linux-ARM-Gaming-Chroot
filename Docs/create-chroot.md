
##Setting up the container
-------------------------

### Install desbootstrap and xhost

For Arch-based Distro(Arch Linux, Manjaro): `sudo pacman -S debootstrap debian-archive-keyring xorg-xhost`

For Debian-based Distro(Mobian, Ubuntu Touch??): `sudo apt install deboostrap debian-archive-keyring x11-xserver-utils`


### Navigate to a directory and Deboostrap container

This will create a secondary root directory that we can use the chroot command to switch to.
```
sudo debootstrap --arch armhf --components=main,universe sid gaming https://deb.debian.org/debian
```
----

###Mounting the container & chroot into it.

There are a few different of going about this. 

#####1. Manually

Here we navigate into the secondary root directory, then mount necessary device and system folders to use the secondary root.

We enable X11 connectivity so we can use graphical applications.

```
cd gaming

sudo mount -t proc /proc proc/

sudo mount -t sysfs /sys sys/

sudo mount --bind /dev dev/

xhost +local

sudo chroot .
```

#####2. Using systemd-nspawn

`systemd-nspawn` can be used to automatically mount the containers essentials while starting it.

```
sudo systemd-nspawn --setenv=DISPLAY=:1 --bind-ro=/tmp/.11-unix -D gaming
```

`--setenv=DISPLAY=:1` sets the DISPLAY variable to be used by X11

`--bind-ro=/tmp/.X11-unix` binds tmp file for X11 to be used (some applications need it for graphical ui.

----

You may have download your terminal for the host Desktop Environment to have proper keyboard functionality

SXMO/SWMO: `apt install foot stterm` 


### Setting bash environment variables

It is best to set these before installing everything.  

Inside the chroot, add PATH and other variables to /root/.bashrc
`vi /root/.bashrc`
or use nano if you are new to linux.
`/bin/nano /root/.bashrc`


You can just copy and paste this.
```
export LC_ALL="C"

export LANGUAGE="C"

export PATH=$PATH:/bin:/sbin:/usr/bin:/usr/sbin:/usr/games:/usr/local/bin:/usr/local/sbin

export STEAMOS=1

export STEAM_RUNTIME=1
```

This next command will source the changes to be used by the programs and distro.

```
source /root/.bashrc
```

### Installing prerequistes
Now we can set up the libraries require to run the programs we want.

At this time we can setup arm64 as well.

`dpkg --add-archiecture arm64` Adds the architecture

`apt update` Updates the Repository Lists

This next command will grab and install the libraries as well as a couple of programs that maybe useful for us later. 

```
apt install sudo vim make cmake git wget gnupg libx11-dev libgl-dev libvulkan-dev libtcmalloc-minimal4 libnm0 zenity chromium alsamixergui libsdl2-dev unzip libgles-dev firefox-esr:arm64 libx11-dev:arm64 libvulkan-dev:arm64 libsdl2-dev:arm64 libgl-dev:arm64 libc6-dev:arm64 libgles-dev:arm64
```

Once this is done installing we can create our user.

-----

[< Brief Introduction](introduction.md) | [Setting up your user >](create-user.md)




