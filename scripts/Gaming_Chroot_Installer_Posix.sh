#!/bin/sh
# Detect whether the user has doas or sudo
if [ -e /etc/doas.conf ] || [ -d /etc/doas.d ]; then
  root=doas
else
  root=sudo
fi

BINDIR=/home/$USER/bin

install_chroot(){
  echo "Before we get start we need 2 things."
  echo "Where do you want to store the chroot? (e.g. /home/user/.local/share/games/gaming_chroot)"
  read GAMING_CHROOT
  echo "$GAMING_CHROOT is where it will be installed."
  $root mkdir -p $GAMING_CHROOT
 
  echo "\nPlease give a  username. Must be all lowercase."
  read USER1

  sleep 15

  echo "\nSetting up chroot.... Please be patient."

  # detect distro and install necessary packages
  # TODO, pmos support (might need some changes to other parts of the script aswell.)
  [ -d /etc/pacman.d ] && $root pacman -S debootstrap debian-archive-keyring xorg-xhost --needed --noconfirm
  [ -d /etc/apt/sources.list ] && $root apt-get -y install deboostrap debian-archive-keyring x11-xserver-utils
  [ -d /etc/apk ] && $root apk add debootstrap xhost
  xhost +local:
  # create chroot
$root debootstrap --arch armhf --components=main,universe sid $GAMING_CHROOT https://deb.debian.org/debian
  # mount all directories
  $root mount -t proc /proc $GAMING_CHROOT/proc/
  $root mount -t sysfs /sys $GAMING_CHROOT/sys/
  $root mount --bind /dev $GAMING_CHROOT/dev/
  $root mount -t devpts devpts $GAMING_CHROOT/dev/pts
  $root mount --bind /run $GAMING_CHROOT/run/
  $root mount --bind $XDG_RUNTIME_DIR $GAMING_CHROOT/run/user/1000
  $root mount -t tmpfs tmpfs $GAMING_CHROOT/tmp/
  #TODO there may be a better way to do this but for now its needed to make internet work reliably, maybe a symlink
  $root cp /etc/resolv.conf $GAMING_CHROOT/etc/resolv.conf
  $root chroot $GAMING_CHROOT /bin/bash -i <<EOF
apt-get -y install foot stterm
dpkg --add-architecture arm64 
echo 'deb http://ftp.us.debian.org/debian/ bookworm main
deb http://ftp.de.debian.org/debian/ bookworm main' >> /etc/apt/sources.list
apt-get -y update
apt-get -y upgrade
apt-get -y install sudo vim make cmake git wget gnupg libx11-dev libgl-dev libvulkan-dev libtcmalloc-minimal4 libnm0 zenity chromium alsamixergui libsdl2-dev unzip libgles-dev firefox-esr:arm64 libx11-dev:arm64 libvulkan-dev:arm64 libsdl2-dev:arm64 libgl-dev:arm64 libc6-dev:arm64 libgles-dev:arm64 xterm
sleep 20
exit
EOF


$root chroot $GAMING_CHROOT <<EOF
echo 'export LC_ALL="C"
export LANGUAGE="C"
export PATH=\$PATH:/bin:/sbin:/usr/bin:/usr/sbin:/usr/games:/usr/local/bin:/usr/local/sbin
export STEAMOS=1
export STEAM_RUNTIME=1' | tee -a /root/.bashrc
EOF

$root chroot $GAMING_CHROOT <<EOF
sleep 10
adduser --home /home/$USER1 $USER1
EOF

$root chroot $GAMING_CHROOT <<EOF
usermod -aG sudo $USER1
EOF

$root chroot $GAMING_CHROOT <<EOF
su $USER1
echo 'export SDL_VIDEODRIVER=wayland
export WAYLAND_DISPLAY=wayland-1
export GDK_BACKEND=wayland
export XDG_SESSION_TYPE=wayland
export XDG_RUNTIME_DIR=/run/user/1000
export DISPLAY=:1
export XSOCKET=/tmp/.X11-unix/X1' | tee -a /home/$USER1/.profile
exit
exit
EOF

$root chroot $GAMING_CHROOT <<EOF
wget https://itai-nelken.github.io/weekly-box86-debs/debian/box86.list -O /etc/apt/sources.list.d/box86.list

wget -O- https://itai-nelken.github.io/weekly-box86-debs/debian/KEY.gpg | sudo apt-key add - 

wget https://ryanfortner.github.io/box64-debs/box64.list -O /etc/apt/sources.list.d/box64.list

wget -O- https://ryanfortner.github.io/box64-debs/KEY.gpg |  gpg --dearmor | sudo tee /usr/share/keyrings/box64-debs-archive-keyring.gpg 

apt-get update && apt-get -y --allow-unauthenticated install box86 box64
exit
EOF

$root cp -r $GAMING_CHROOT/etc/binfmt.d/box* /etc/binfmt.d/
if [ -d /etc/apk ]; then
	  $root rc-service restart binfmt
  else
	    $root systemctl restart systemd-binfmt
fi
$root chroot $GAMING_CHROOT /bin/bash -i <<EOF
cd /tmp
wget http://ftp.debian.org/debian/pool/main/libi/libindicator/libindicator7_0.5.0-4_armhf.deb
wget http://ftp.debian.org/debian/pool/main/liba/libappindicator/libappindicator1_0.4.92-7_armhf.deb
apt-get -y install ./lib*
wget https://repo.steampowered.com/steam/archive/stable/steam_latest.deb
apt-get -y install ./steam_latest.deb
EOF

mkdir /home/$USER/bin
echo 'export PATH=$PATH:/home/$USER/bin' >> /home/$USER/.profile

  $root echo "#!/bin/bash

  # CHANGE ME TO DESIRED CHROOT DIRECTORY
  CHROOTDIR=$GAMING_CHROOT

  cd \$CHROOTDIR

  $root mount -t proc /proc \$CHROOTDIR/proc
  $root mount -t sysfs /sys \$CHROOTDIR/sys
  #$root mount --bind /lib/dri \$CHROOTDIR/lib/dri
  $root mount --bind /dev \$CHROOTDIR/dev
  $root mount -t devpts devpts \$CHROOTDIR/dev/pts
  $root mount --bind /run \$CHROOTDIR/run
  $root mount --bind $XDG_RUNTIME_DIR \$CHROOTDIR/run/user/1000
  $root mount -t tmpfs tmpfs \$CHROOTDIR/tmp
  #$root mount --bind \$CHROOTDIR/../steamapps \$CHROOTDIR/home/$USER1/.local/share/Steam/steamapps
  #$root mount --bind \$CHROOTDIR/../wine-games \$CHROOTDIR/home/$USER1/wine-games
  $root chmod 1777 \$CHROOTDIR/proc \$CHROOTDIR/sys \$CHROOTDIR/dev \$CHROOTDIR/dev/shm \$CHROOTDIR/dev/pts \$CHROOTDIR/run \$CHROOTDIR/run/user/1000 \$CHROOTDIR/tmp
  $root chroot \$CHROOTDIR /bin/bash -i <<EOF
  su $USER1
  cd ~/
  MESA_GL_VERSION_OVERRIDE=3.2 MESA_GLSL_VERSION_OVERRIDE=150 steam +open steam://open/minigameslist
  sleep 2
  exit
  EOF
  sleep 5
  $root umount \$CHROOTDIR/run/user/1000 \$CHROOTDIR/run \$CHROOTDIR/dev/pts \$CHROOTDIR/*
  exit" > $BINDIR/steam-box
  #$root cp -r $BINDIR/steam-box /usr/local/bin/
  $root chmod +x $BINDIR/steam-box


  $root mkdir /opt/steam
  curl -o /tmp/steam.ico https://store.steampowered.com/favicon.ico
  $root cp -r /tmp/steam.ico /opt/steam/steam.ico

  echo "[Desktop Entry]
  Encoding=UTF-8
  Version=1.0
  Type=Application
  Terminal=false
  Exec=/home/$USER/bin/steam-box
  Name=Name of Application
  Icon=/opt/steam/steam.ico" > /tmp/steam.desktop
  $root cp -r /tmp/steam.desktop /usr/share/applications


  $root echo "#!/bin/bash

  # CHANGE ME TO DESIRED CHROOT DIRECTORY
  CHROOTDIR=$GAMING_CHROOT

  cd \$CHROOTDIR

  $root mount -t proc /proc \$CHROOTDIR/proc
  $root mount -t sysfs /sys \$CHROOTDIR/sys
  #$root mount --bind /lib/dri \$CHROOTDIR/lib/dri
  $root mount --bind /dev \$CHROOTDIR/dev
  $root mount -t devpts devpts \$CHROOTDIR/dev/pts
  $root mount --bind /run \$CHROOTDIR/run
  $root mount --bind $XDG_RUNTIME_DIR \$CHROOTDIR/run/user/1000
  $root mount -t tmpfs tmpfs \$CHROOTDIR/tmp
  $root cp -r /etc/resolv.conf \$CHROOTDIR/etc/resolv.conf
  $root chmod 1777 \$CHROOTDIR/proc \$CHROOTDIR/sys \$CHROOTDIR/dev \$CHROOTDIR/dev/shm \$CHROOTDIR/dev/pts \$CHROOTDIR/run \$CHROOTDIR/run/user/1000 \$CHROOTDIR/tmp
  $root chroot \$CHROOTDIR /bin/bash
  sleep 5
  $root umount \$CHROOTDIR/run/user/1000 \$CHROOTDIR/run \$CHROOTDIR/dev/pts \$CHROOTDIR/*
  exit" > $BINDIR/gaming-chroot-terminal
  #$root cp -r ./scripts/gaming-chroot-terminal /usr/local/bin/
  $root chmod +x $BINDIR/gaming-chroot-terminal

  $root echo "#!/bin/bash
  
  # CHANGE ME TO DESIRED CHROOT DIRECTORY
  CHROOTDIR=$GAMING_CHROOT
  cd \$CHROOTDIR
  
  $root mount -t proc /proc \$CHROOTDIR/proc
  $root mount -t sysfs /sys \$CHROOTDIR/sys
  $root mount --bind /dev \$CHROOTDIR/dev
  $root mount -t devpts devpts \$CHROOTDIR/dev/pts
  $root mount --bind /run \$CHROOTDIR/run
  $root mount --bind $XDG_RUNTIME_DIR \$CHROOTDUR/run/user/1000
  $root mount -t tmpfs tmpfs \$CHROOTDIR/tmp
  $root chmod 1777 \$CHROOTDIR/proc \$CHROOTDIR/sys \$CHROOTDIR/dev \$CHROOTDIR/dev/pts \$CHROOTDIR/dev/shm \$CHROOTDIR/run \$CHROOTDIR/run/user/1000 \$CHROOTDIR/tmp
  $root chroot \$CHROOTDIR /bin/bash -i  <<'EOF'
  source /root/.bashrc
  apt-get update && apt-get upgrade
  exit
  EOF
  sleep 5
  $root umount \$CHROOTDIR/dev/pts \$CHROOTDIR/run/user/1000 \$CHROOTDIR/*
  exit" > $BINDIR/update-chroot
  #$root cp -r $BINDIR/update-chroot /usr/local/bin/
  $root chmod +x $BINDIR/update-chroot

  

  
  #echo "cd $GAMING_CHROOT
  #$root mount -t proc /proc proc/
  #$root mount -t sysfs /sys sys/
  #$root mount --bind /dev dev/
  #$root mount -t devpts devpts dev/pts
  #$root mount --bind /run run/
  #$root mount --bind /run/user/1000 run/user/1000
  #$root mount -t tmpfs tmpfs tmp/
  #$root cp /etc/resolv.conf etc/resolv.conf
  #" > mount_chroot.sh
  #chmod +x ./mount_chroot.sh
 
  $root umount -R $GAMING_CHROOT/dev/pts $GAMING_CHROOT/run/user/1000 $GAMING_CHROOT/*

  echo "\n\n\n A chroot has been created at $GAMING_CHROOT with user $USER1, to go into it run gaming-chroot-terminal from terminal or the mount_chroot.sh script now found in this directory and then cd into the chroot directory, you can then run '$root chroot .' and finally 'su user\`'"
  echo "To run steam then run steam-box from host terminal or the following command 'steam +open steam://open/minigameslist' inside the chroot as a user."
  echo "See https://github.com/Raezroth/Linux-ARM-Gaming-Chroot for more information"


}

maintenance_mode() {
		exec $BINDIR/gaming-chroot-terminal
}

update_chroot() {
		exec $BINDIR/update-chroot
}

experimental_repos() {
		echo "Give the absolute path to the chroot: "
		read $DEV_REPO
		echo 'deb https:/deb.debian.org/debian experimental main contrib' | doas tee -a $DEV_REPO/etc/apt/sources.list
		exec $BINDIR/update-chroot
}

uninstall_chroot() {
		BINDIR=/home/$USER/bin
		echo "Give the absolute path to the chroot: "
		read DELDIR

		echo "Making sure it is umounted..."
		$root umount -R $DELDIR/dev/pts $DELDIR/run/user/1000 $DELDIR/*
		
		echo "Deleting Chroot and Files..."
		$root rm -r $DELDIR
		$root rm -r /usr/share/applications/steam.desktop $BINDIR/steam-box $BINDIR/gaming-chroot-terminal /opt/steam

		echo "Uninstall complete! Have a nice day!"
}
main_menu() {
  
  echo "\n\n\n		EXPERIMENTAL-LINUX-ARM-GAMING-CHROOT-INSTALLER\n 	    		VER. 0.2.0 08/08/2022\n"
  echo "Please type the number relating to what you want to do.\n"
  echo "[0] Install Steam Gaming Chroot"
  echo "[1] Install Wine into Chroot"
  echo "[2] Maintenance Mode"
  echo "[3] Update Chroot"
  echo "[4] Add Experimental Repos (for latest Mesa packages)"
  echo "[5] Uninstall Chroot. BACKUP ANY DATA YOU WISH TO SAVE FROM CHROOT FIRST!"
  echo "[6] Exit"
  read option
}
read_menu(){
  main_menu 
  [ $option = 0 ] && install_chroot && read_menu
  [ $option = 1 ] && echo "Install Wine" && read_menu
  [ $option = 2 ] && maintenance_mode && read_menu
  [ $option = 3 ] && update_chroot && read_menu
  [ $option = 4 ] && experimental_repos && read_menu
  [ $option = 5 ] && uninstall_chroot && read_menu
  [ $option = 6 ] && exit
  echo "Invalid option, please try again." && read_menu
}
read_menu
