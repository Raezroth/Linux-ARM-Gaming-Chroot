# Pinephone-Gaming-Chroot

Guide to setup a MultiArch Chroot container to run Steam and Wine.

Please make sure to read, I put alot of time to try to make this as newbie friendly as possible.

To see a list of games I've tested: [PinePhone(A64)](https://github.com/Raezroth/Pinephone-Gaming-Chroot/blob/master/PPBE-A64-Tested-Games.md), [PinePhone Pro(RK3399s)](https://github.com/Raezroth/Pinephone-Gaming-Chroot/blob/master/PPP-Tested-Games.md)


Pictures of Steam and a few games running at bottom.

Launch scripts and possible auto installer script coming soon.?.?.?.?...

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

sudo chroot .
```

Note: When using sxmo/swmo, you will need to install your DE's terminal: ```apt install foot stterm``` and chroot back into the container to fix backspace and arrow keys. 

### Inside the chroot, add PATH and other variables to /root/.bashrc
```vi /root/.bashrc```
or use nano if you are new to linux.
```/bin/nano /root/.bashrc```


You can just copy and paste this.
```
export LC_ALL="C"

export LANGUAGE="C"

export PATH=$PATH:/bin:/sbin:/usr/bin:/usr/sbin:/usr/games:/usr/local/bin:/usr/local/sbin

export STEAMOS=1

export STEAM_RUNTIME=1
```
This will source the changes to be used
```
source /root/.bashrc
```

### Install some packages and create user.
```
apt install sudo vim make cmake git wget gnupg libx11-dev libgl-dev libvulkan-dev libtcmalloc-minimal4 libnm0 zenity chromium libsdl2-dev unzip libgles-dev
```

You may have to do this for other Desktop Enviroments.

### Set chroot's user and password for root and user

Note: Replace your_user with your preferred username when creatinging a user. 

```
adduser --home /home/your_user your_user 
```

Next add your_user to users group

```
usermod -g users your_user
```
These next commands set your passwords in combination with the corrisponding user.

```
passwd your_user
```

Remember to set root to something complex. 
```
passwd root
```

### Add your_user to visudo then change to your_user
```EDITOR=vim visudo```
or use nano if you are new to linux
```EDITOR=nano visudo```


```
root	ALL=(ALL:ALL) ALL

your_user 	ALL=(ALL:ALL) ALL
```

Note: There is a bug where the home folder doesn't always get created. We must create one ourselves.
```mkdir /home/your_user```
Then ```chown``` it to your_user
```chown your_user /home/your_user```

Now change to your user.
```
su your_user
```

When you change to your_user, it will still be in the previous direcotry you were in as root. We must change to our home directory.
```cd ~/```



### Copy the sources for box86 & gl4es and compile them.
```
wget https://github.com/ptitSeb/box86/archive/refs/tags/v0.2.4.tar.gz

tar -xvf v0.2.4.tar.gz

git clone https://github.com/ptitSeb/gl4es

cd ~/gl4es; mkdir build; cd build; cmake ../; make -j$(nproc); sudo make install
```
For PinePhone (A64)
```
cd ~/box86*; mkdir build; cd build; cmake ../ -DA64=1; make -j$(nproc); sudo make install
```
For PinePhone Pro (RK3399s)
```
cd ~/box86*; mkdir build; cd build; cmake ../ -DRK3399=1; make -j$(nproc); sudo make install

```

### Outside the chroot container 
Here we must copy box86.conf from chroot to host and restart host systemd-binfmt so BOX86 will run automatically when launching x86 applications.

NOTE: You don't have to quit the chroot. Just open another terminal.
```
sudo cp -r PATH_TO_CHROOT/etc/binfmt.d/box86.conf /etc/binfmt.d/

sudo systemctl restart systemd-binfmt
```

### Inside the container install steam and libappindicator1, then add i386 multiarch after steam has launched.
These commands will create a Downloads Folder and use it to store required install files. You can clear this folder after install.
```
mkdir ~/Downloads

cd ~/Downloads

wget http://ftp.debian.org/debian/pool/main/libi/libindicator/libindicator7_0.5.0-4_armhf.deb

wget http://ftp.debian.org/debian/pool/main/liba/libappindicator/libappindicator1_0.4.92-7_armhf.deb

sudo apt install ./lib*

wget https://repo.steampowered.com/steam/archive/stable/steam_latest.deb

sudo apt install ./steam_latest.deb

cd ~/
```


### Launch steam into mini games list

Remember that  ``` sudo chmod 1777 /dev/shm``` needs to be ran before running Steam, This will only have to be done after every reboot.

This command will set the architecture to linux32 to use 32bit libraries only. This is so Steam doesn't register 64bit pins right away, if it does it may cause issues later.
```setarch-L linux32 steam +open steam://open/minigameslist```

After installing BOX64 in [PART 2](https://github.com/Raezroth/Pinephone-Gaming-Chroot#part-2) you can just run ```steam +open steam://open/minigameslist``` to use both BOX86 and BOX64


Since this is a chroot, you will have to remount ```/dev```, ```/proc```, & ```/sys``` on reboot.

```
sudo mount -t proc /proc proc/

sudo mount -t sysfs /sys sys/

sudo mount --bind /dev dev/

xhost +local:

```

----


### To open a specific steam game, to get $STEAMAPPID go to [SteamDB](https://steamdb.info/apps/)
```steam +open steam://rungameid/$STEAMAPPID```

Note: when launching a game this way, Steam will be mimized and almost impossible to bring back up. You can do one of following things:

1. Kill the task with htop. Must have htop installed
2.1. Use ```ps a``` the display a list of runnning tasks and find the PID for Steam.
2.2. Then use ```kill -9 PID``` to kill the process.

### To use gl4es with specific steam game, Do not use gl4es with steam mini games list.
```
BOX86_LIBGL=/usr/lib/gl4es/libGL.so.1 steam +open steam://rungameid/$STEAMAPPID
```
-----


### To improve performance

1. Set Steam Library setting to Low Bandwisth Mode and Low Performance Mode
2. Disable Broadcasting
3. Disable Remote Play. This is broken anyways.
4. If you use a skin, be carefull. Some tax Steam's Interface.
5. Launch with:
	
	For Pinephone (A64): ```BOX86_LOG=0 BOX64_LOG=0 steam -single_core +open steam://open/minigameslist 2> tee ~/steam.log```
	
	For Pinephone Pro (RK3399s): ```BOX86_LOG=0 BOX64_LOG=0 MESA_GL_VERSION_OVERRIDE=3.2 PAN_MESA_DEBUG=gl3 steam -single_core +open steam://open/minigameslist 2> tee steam.log```
	
	This will redirect output to a file. Improves performance a bit.
	
	Note: I left the override for opengl 3 in there because it doesn't hurt anything, yet makes more games able to launch from library list.

6. Run all games on low obviously. Alot of games crash loading in from menus due to texture overloading.
 
-------

## Uninstalling Steam games.
### To uninistall games:
1. Close Steam
2. Grab ```APPID``` from [SteamDB](https://steamdb.info/apps/)
3. Delete game from ```PATH_TO_STEAMLIBRARY/common/```
4. Delete ```appmanifest_APPID.acf``` from ```PATH_TO_STEAMLIBRARY/```
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
Here we added arm64 architecture, update debian sources, and install some requirements to install BOX64 and run x86_64 applications
```
sudo dpkg --add-architecture arm64 

sudo apt update

sudo apt install firefox-esr:arm64 gcc:arm64 libx11-dev:arm64 libvulkan-dev:arm64 libsdl2-dev:arm64 libgl-dev:arm64 libc6-dev:arm64 libgles-dev:arm64

cd ~/

wget https://github.com/ptitSeb/box64/archive/fbb534917a028aaae2dd6b79900425dbe5617112.zip

unzip fbb534917a028aaae2dd6b79900425dbe5617112.zip

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
Here we must copy box64.conf from chroot to host and restart host systemd-binfmt so BOX64 will run automatically when launching x86_64 applications.

NOTE: You don't have to quit the chroot. Just open another terminal.
```
sudo cp -r PATH_TO_CHROOT/etc/binfmt.d/box64.conf /etc/binfmt.d/
sudo systemctl restart systemd-binfmt
```
### If everything went well you should now be able to launch 64bit applications while still being able to launch steam

---------

## Installing Wine 

### Instructions for installing Wine for Box86 can be found [here](https://github.com/ptitSeb/box86/blob/master/docs/X86WINE.md)

Note: Doing this may or may not break Steam. It's worth the risk to try in my opinion.

----------

## Uninstalling the chroot

Navigate to chroot directoy, mine is /home/alarm/chroot/gaming

Inside the chroot folder umount /dev, /proc, & /sys

```sudo umount ./*```  This is if you are inside /home/$USER/chroot/gaming directory

```sudo umount gaming/*```  If you are in the folder /home/$USER/chroot 

From /home/alarm/chroot run ```sudo rm -r gaming/```

Removing debootstrap and xhost

For Arch-based Distro(Arch Linux, Manjaro): ```sudo pacman -R debootstrap debian-archive-keyring xorg-xhost```

For Debian-based Distro(Mobian, Ubuntu Touch??): ```sudo apt remove deboostrap debian-archive-keyring x11-xserver-utils```




--------

### Tested On: 

Device: ```PinePhone & PinePhone Pro```

Distro: ```Arch Linux Arm w/ Debian multiarch chroot```

Inputs: ```Touchscreen, Dualsense Controller, Xbox One Controller, Power-A Switch Controller```

### NOTE: Touchscreen Controller input is experimental use at your own risk.

### [TabPad](https://github.com/nitg16/TabPad) must be ran from a seperate terminal.

Recommend to launch another terminal and chroot into the container again for this. You can try to run this from the host, but TabPad relies on X11 and won't launch with wayland currently. Looking into modifying or just a new touchscreen controller.



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


