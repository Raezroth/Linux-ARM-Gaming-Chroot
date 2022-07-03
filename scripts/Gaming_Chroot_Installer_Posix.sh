#!/bin/sh
# Detect whether the user has doas or sudo
if [ -e /etc/doas.conf ]; then
  root=doas
else
  root=sudo
fi

install_chroot(){
  echo "Before we get start we need 1 thing."
  echo "Where do you want to store the chroot? (e.g. /home/user/.local/share/games/gaming_chroot)"
  read GAMING_CHROOT
  echo "$GAMING_CHROOT is where it will be installed."
  $root mkdir -p $GAMING_CHROOT
  
  # detect distro and install necessary packages
  # TODO, pmos support (might need some changes to other parts of the script aswell.)
  [ -d /etc/pacman.d ] && $root pacman -S debootstrap debian-archive-keyring xorg-xhost xorg-server-xephyr --needed --noconfirm
  [ -d /etc/apt/sources.list ] && $root apt-get -y install deboostrap debian-archive-keyring x11-xserver-utils
  xhost +local:
  # create chroot
$root debootstrap --arch armhf --components=main,universe sid $GAMING_CHROOT https://deb.debian.org/debian
  # mount all directories
  cd $GAMING_CHROOT
  $root mount -t proc /proc proc/
  $root mount -t sysfs /sys sys/
  $root mount --bind /dev dev/
  $root mount -t devpts devpts dev/pts
  $root mount --bind /run run/
  $root mount --bind /run/user/1000 run/user/1000
  $root mount -t tmpfs tmpfs tmp/
  #TODO there may be a better way to do this but for now its needed to make internet work reliably, maybe a symlink
  $root cp /etc/resolv.conf etc/resolv.conf
  $root chroot . <<EOF
apt-get -y install foot stterm

dpkg --add-architecture arm64 
apt-get -y update
apt-get -y upgrade
apt-get -y install sudo vim make cmake git wget gnupg libx11-dev libgl-dev libvulkan-dev libtcmalloc-minimal4 libnm0 zenity chromium alsamixergui libsdl2-dev unzip libgles-dev firefox-esr:arm64 libx11-dev:arm64 libvulkan-dev:arm64 libsdl2-dev:arm64 libgl-dev:arm64 libc6-dev:arm64 libgles-dev:arm64 xterm
useradd -m user1
usermod -aG users sudo user1
echo "user1:gaming" | chpasswd
echo "root:gaming" | chpasswd
chsh user1 -s /bin/bash
mkdir /home/user1
chown user1 /home/user1
echo 'export LC_ALL="C"

export LANGUAGE="C"

export PATH=\$PATH:/bin:/sbin:/usr/bin:/usr/sbin:/usr/games:/usr/local/bin:/usr/local/sbin

export SDL_VIDEODRIVER=wayland

export WAYLAND_DISPLAY=wayland-1

export GDK_BACKEND=wayland

export XDG_SESSION_TYPE=wayland

export XDG_RUNTIME_DIR=/run/user/1000

export DISPLAY=:1

export XSOCKET=/tmp/.X11-unix/X1

export STEAMOS=1

export STEAM_RUNTIME=1' > /home/user1/.bashrc
source /home/user1/.bashrc
cd /tmp
wget 'https://github.com/Raezroth/Linux-ARM-Gaming-Chroot/releases/download/Nightly-0626/box64_0.1.8_arm64_0626.deb'
wget 'https://github.com/Raezroth/Linux-ARM-Gaming-Chroot/releases/download/Nightly-0626/box86_0.2.6_armhf_0626.deb'
apt-get -y install ./box*.deb


EOF
$root cp -r $GAMING_CHROOT/etc/binfmt.d/box* /etc/binfmt.d/
$root systemctl restart systemd-binfmt
$root chroot . <<EOF
cd /tmp
wget http://ftp.debian.org/debian/pool/main/libi/libindicator/libindicator7_0.5.0-4_armhf.deb
wget http://ftp.debian.org/debian/pool/main/liba/libappindicator/libappindicator1_0.4.92-7_armhf.deb
apt-get -y install ./lib*
wget https://repo.steampowered.com/steam/archive/stable/steam_latest.deb
apt-get -y install ./steam_latest.deb
EOF

}

maintenance_mode() {
  exec /bin/gaming_chroot_terminal.sh
}

uninstall_chroot() {
		echo "Give the absolute path to the chroot: "
		read DELDIR

		echo "Making sure it is umounted..."
		$root umount -R $DELDIR/dev/pts $DELDIR/run/user/1000 $DELDIR/*
		
		echo "Deleting Chroot and Files..."
		$root rm -r $DELDIR
		$root rm -r /usr/share/applications/steam.desktop /bin/start-steam.sh /bin/gaming_chroot_terminal.sh

		echo "Uninstall complete! Have a nice day!"
}
main_menu() {
  echo "		EXPERIMENTAL-LINUX-ARM-GAMING-CHROOT-INSTALLER\n 	    		VER. 0.1.B 06/05/2022\n"
  echo "Please type the number relating to what you want to do."
  echo "[0] Install Steam Gaming Chroot"
  echo "[1] Install Wine into Chroot"
  echo "[2] Maintenance Mode"
  echo "[3] Uninstall Chroot. BACKUP ANY DATA YOU WISH TO SAVE FROM CHROOT FIRST!"
  echo "[4] Exit"
  read option
}
read_menu(){
  main_menu 
  [ $option = 0 ] && install_chroot && exit
  [ $option = 1 ] && echo "Install Wine" && exit
  [ $option = 2 ] && maintenance_mode && exit
  [ $option = 3 ] && uninstall_chroot && exit
  [ $option = 4 ] && exit
  echo "Invalid option, please try again." && read_menu
}
read_menu
