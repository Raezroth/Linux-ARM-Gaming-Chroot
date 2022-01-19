# Pinephone-Gaming-Chroot

Guide to setup a MultiArch Chroot container to run Steam and Wine.

Pictures at bottom.

-----
## Getting Started!

### Install desbootstrap and xhost

For Arch-based Distro(Arch Linux, Manjaro): ```sudo pacman -S debootstrap debian-archive-keyring xorg-xhost```

For Debian-based Distro(Mobian, Ubuntu Touch??): ```sudo apt install deboostrap debian-archive-keyring x11-xserver-utils```


### Navigate to a directory and Deboostrap container
```
sudo debootstrap --arch armhf bullseye gaming https://deb.debian.org/debian
```

### Mount container & chroot into it.
```
cd gaming

sudo mount -t proc /proc proc/

sudo mount -t sysfs /sys sys/

sudo mount --bind /dev dev/

xhost +local:

sudo chmod 1777 /dev/shm

sudo chroot .
```

### Add PATH to /root/.bashrc
```
vi /root/.bashrc

export LC_ALL="C"

export LANGUAGE="C"

export PATH=$PATH:/bin:/sbin:/usr/bin:/usr/sbin:/usr/games:/usr/local/bin:/usr/local/sbin

export STEAMOS=1

export STEAM_RUNTIME=1

source /root/.bashrc
```

### Install some packages and create user.
```
apt install sudo vim make cmake git wget gnupg libx11-dev libgl-dev libvulkan-dev libtcmalloc-minimal4 libnm0 zenity chromium libsdl2-dev unzip libgles-dev
```

Note: When using sxmo/swmo, you will need to install your DE's terminal: ```sudo apt install foot stterm```. 
You may have to do this for other Desktop Enviroments.

### Set chroot's user and password for root and user
Note: Replace your_user with your preferred username when creatinging a user. 

```
adduser --home /home/your_user your_user 

usermod -g users your_user

passwd your_user

passwd root
```

### Add $USER to visudo then change to $USER
```
EDITOR=vim visudo


root	ALL=(ALL:ALL) ALL

your_user 	ALL=(ALL:ALL) ALL

 
su $USER

cd ~/
```


### git clone repos for box86 & gl4es
```
wget https://github.com/ptitSeb/box86/archive/refs/tags/v0.2.4.tar.gz

tar -xvf v0.2.4.tar.gz

git clone https://github.com/ptitSeb/gl4es

cd ~/gl4es; mkdir build; cd build; cmake ../; make -j$(nproc); sudo make install
```
### For PinePhone (A64)
```
cd ~/box86*; mkdir build; cd build; cmake ../ -DA64=1; make -j$(nproc); sudo make install
```
### For PinePhone Pro (RK3399s)
```
cd ~/box86*; mkdir build; cd build; cmake ../ -DRK3399=1; make -j$(nproc); sudo make install

```

### Outside the chroot container 
```
sudo cp -r PATH_TO_CHROOT/etc/binfmt.d/box86.conf /etc/binfmt.d/

sudo systemctl restart systemd-binfmt
```

### Chroot back intoo the container and Install steam and libappindicator1, then add i386 multiarch after steam has launched.
```
mkdir ~/Downloads

cd ~/Downloads

wget http://ftp.debian.org/debian/pool/main/libi/libindicator/libindicator7_0.5.0-4_armhf.deb

wget http://ftp.debian.org/debian/pool/main/liba/libappindicator/libappindicator1_0.4.92-7_armhf.deb

sudo apt install ./lib*

wget https://repo.steampowered.com/steam/archive/stable/steam_latest.deb

sudo apt install ./steam_latest.deb
```


### Launch steam into mini games list
```
setarch-L linux32 steam +open steam://open/minigameslist
```

After installing BOX64 you can just run ```steam +open steam://open/minigameslist``` to use both BOX86 and BOX64


Remember ``` sudo chmod 1777 /dev/shm``` needs to be ran before running Steam after every reboot.

Since this is a chroot, you will have to remount ```/dev```, ```/proc```, & ```/sys```.

You can just combine the mount and chmod command when starting the container.

```
sudo mount -t proc /proc proc/

sudo mount -t sysfs /sys sys/

sudo mount --bind /dev dev/

xhost +local:

sudo chmod 1777 /dev/shm
```

----


### To open a specific steam game, to get $STEAMAPPID go to [SteamDB](https://steamdb.info/apps/)
```
steam +open steam://rungameid/$STEAMAPPID
```


### To use gl4es with specific steam game, Do not use gl4es with steam mini games list.
```
LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib/gl4es steam +open steam://rungameid/$STEAMAPPID
```
-----


## Uninstalling Steam games.
### To uninistall games:
1. Close Steam
2. Grab APPID from [SteamDB](https://steamdb.info/apps/)
3. Delete game from PATH_TO_STEAMLIBRARY/common/
4. Delete appmanifest_APPID.acf from PATH_TO_STEAMLIBRARY/
5. Launch Steam again and the game should be uninstalled.


---------

---
### Notes
--- 
### - Big Picture Mode Crashes on PinePhone and PinePhone Pro, even with gl4es.
###  
### + Conrtollers Work with some games.	
###
### - Proton doesn't work
### 
### - Steam doesn't work in a arm64 chroot enviroment, that's why we start with armhf then use debian multiarch (Part 2)



----------


# PART 2

# Adding Box64 for 64bit

### Setup prerequisites 
```
sudo dpkg --add-architecture arm64 

sudo apt update

sudo apt install firefox-esr:arm64 gcc:arm64 libx11-dev:arm64 libvulkan-dev:arm64 libsdl2-dev:arm64 libgl-dev:arm64 libc6-dev:arm64 libgles-dev:arm64

cd ~/

wget https://github.com/ptitSeb/box64/archive/fbb534917a028aaae2dd6b79900425dbe5617112.zip

unzip box64-fbb534917a028aaae2dd6b79900425dbe5617112.zip

```
### For PinePhone (A64)
```
cd ~/box64*; mkdir build; cd build; cmake ../ -DA64=1; make -j$(nproc); sudo make install
```
### For PinePhone Pro (RK3399s)
```
cd ~/box64*; mkdir build; cd build; cmake ../ -DRK3399=1; make -j$(nproc); sudo make install
```


### Outside the chroot container 
```
sudo cp -r PATH_TO_CHROOT/etc/binfmt.d/box64.conf /etc/binfmt.d/
sudo systemctl restart systemd-binfmt
```
### If everything went well you should now be able to launch 64bit applications while still being able to launch steam

---------

## Installing Wine 
### Instructions for installing Wine for Box86 can be found [here](https://github.com/ptitSeb/box86/blob/master/docs/X86WINE.md)

----------

# Uninstalling the chroot

### Navigate to chroot directoy, mine is /home/alarm/chroot/gaming

### Inside the chroot folder umount /dev, /proc, & /sys

```
	sudo umount ./*  #This is if you are inside /home/alarm/chroot/gaming directory

	sudo umount gaming/* # If you are in the folder /home/alarm/chroot 
```
### From /home/alarm/chroot run
```
	sudo rm -r gaming/ 
```

### Removing debootstrap and xhost
For Arch-based Distro(Arch Linux, Manjaro): ```sudo pacman -R debootstrap debian-archive-keyring xorg-xhost```

For Debian-based Distro(Mobian, Ubuntu Touch??): ```sudo apt remove deboostrap debian-archive-keyring x11-xserver-utils```




--------

### Tested On: 
Device: PinePhone & PinePhone Pro 
Distro: Arch Linux Arm w/ Debian multiarch chroot
Inputs: Touchscreen, Dualsense Controller, Xbox One Controller, Power-A Switch Controller

### NOTE: Touchscreen Controller input is experimental use at your own risk.

### [TabPad](https://github.com/nitg16/TabPad) must be ran from a seperate terminal.

Recommend to launch another terminal and chroot into the container again for this.



---
### Checkout ptitSeb's BOX86, BOX64, & GL4ES githubs at these links. This project is the real hero here!!!! 
 BOX86 [Here](https://github.com/ptitSeb/box86)
 BOX86-COMPATIBILITY-LIST [Here](https://github.com/ptitSeb/box86-compatibility-list) Go to issues.
 BOX64 [Here](https://github.com/ptitSeb/box64)
 GL4ES [Here](https://github.com/ptitSeb/gl4es) 



---------

# Steam
![Steam](https://github.com/Raezroth/Pinephone-Gaming-Chroot/blob/master/IMG_20211104_012947.jpg)

# Steam-DST
![Steam-DST](https://github.com/Raezroth/Pinephone-Gaming-Chroot/blob/master/IMG_20211122_182954.jpg)

# Steam Team Fortress Classic

![Steam-TFC](https://github.com/Raezroth/Pinephone-Gaming-Chroot/blob/master/IMG_20211123_020518.jpg)


