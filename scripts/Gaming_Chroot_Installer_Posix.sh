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
  [ -d /etc/pacman.d ] && $root pacman -S debootstrap xorg-xhost
  [ -d /etc/apt/sources.list ] && $root apt install debootstrap xhost-xorg
  xhost +local:
  # create chroot
	$root debootstrap --arch armhf --components=main,universe sid $GAMING_CHROOT https://deb.debian.org/debian
  # mount all directories
	$root mount -t proc /proc $GAMING_CHROOT/proc
	$root mount -t sysfs /sys $GAMING_CHROOT/sys
	$root mount --bind /dev $GAMING_CHROOT/dev
	$root mount -t devpts devpts $GAMING_CHROOT/dev/pts
	$root mount --bind /run $GAMING_CHROOT/run
	$root mount --bind /run/user/1000 $GAMING_CHROOT/run/user/1000
	$root mount -t tmpfs tmpfs $GAMING_CHROOT/tmp
	$root chmod 1777 $GAMING_CHROOT/proc $GAMING_CHROOT/sys $GAMING_CHROOT/dev \
			$GAMING_CHROOT/dev/pts $GAMING_CHROOT/run \ 
		       	$GAMING_CHROOT/run/user/1000 $GAMING_CHROOT/tmp
	$root chroot $CHROOTDIR /bin/bash << EOF
		echo "export LC_ALL=\"C\""                 >> /root/.bashrc
		echo "export LANGUAGE=\"C\""               >> /root/.bashrc
		echo "export PATH=\$PATH:/bin:/sbin:/usr/bin:/usr/sbin:/usr/games:/usr/local/bin:/usr/local/sbin" >> /root/.bashrc
		echo "export STEAMOS=1"                    >> /root/.bashrc
		echo "export STEAM_RUNTIME=1"              >> /root/.bashrc
		echo "chmod 177 /dev/shm"                  >> /root/.bashrc
		echo "export MESA_GL_VERSION_OVERRIDE=3.2" >> /root/.bashrc
		echo "export PAN_MESA_DEBUG=gl3"           >> /root/.bashrc
		echo "export PULSE_SERVER=127.0.0.1"       >> /root/.bashrc
		source /root/.bashrc
		dpkg --add-architecture arm64
		apt update
		apt install -y sudo vim make cmake git wget gnupg libx11-dev libgl-dev \
		libvulkan-dev libtcmalloc-minimal4 libnm0 zenity chromium alsamixergui libsdl2-dev unzip \
		libgles-dev firefox-esr:arm64 libx11-dev:arm64 libvulkan-dev:arm64 libsdl2-dev:arm64 \
		libgl-dev:arm64 libc6-dev:arm64 libgles-dev:arm64
		adduser --home /home/steam-user --gecos "" --disabled-password user
		echo "user:password" | chpasswd
		usermod -g users steam-user
		adduser stema-user sudo
		su steam-user -
		cd ~/
		echo "export SDL_VIDEODRIVER=wayland" >> ~/.bash_profile
		echo "export WAYLAND_DISPLAY=wayland-1" >> ~/.bash_profile
		echo "export GDK_BACKEND=wayland" >> ~/.bash_profile
		echo "export XDG_SESSION_TYPE=wayland" >> ~/.bash_profile
		mkdir Downloads
		cd Downloads
		wget https://github.com/Raezroth/Linux-ARM-Gaming-Chroot/releases/download/0.2.6%2F0.1.8/box64_0.1.8_sid_generic__arm64.deb
		wget https://github.com/Raezroth/Linux-ARM-Gaming-Chroot/releases/download/0.2.6%2F0.1.8/box86_0.2.6_sid_generic_armhf.deb
		wget http://ftp.debian.org/debian/pool/main/libi/libindicator/libindicator7_0.5.0-4_armhf.deb
		wget http://ftp.debian.org/debian/pool/main/liba/libappindicator/libappindicator1_0.4.92-7_armhf.deb
		exit
		apt install -y /home/user/Downloads/*.deb
		su steam-user -
		cd ~/Downloads
		wget https://repo.steampowered.com/steam/archive/stable/steam_latest.deb
		exit
		apt install -y /home/user/Downloads/steam_latest.deb
EOF
	echo "Setting up necessary files."
	
	$root cp $GAMING_CHROOT/etc/binfmt.d/box86.conf /etc/binfmt.d
	$root cp $GAMING_CHROOT/etc/binfmt.d/box64.conf /etc/binfmt.d
	$root systemctl restart systemd-binfmt

  # Create a helper script to launch the chroot with steam
	$root echo "cd $GAMING_CHROOT
       
sudo mount -t proc /proc $GAMING_CHROOT/proc
sudo mount -t sysfs /sys $GAMING_CHROOT/sys
sudo mount --bind /dev $GAMING_CHROOT/dev
sudo mount -t devpts devpts $GAMING_CHROOT/dev/pts
sudo mount --bind /run $GAMING_CHROOT/run
sudo mount --bind /run/user/1000 $GAMING_CHROOT/run/user/1000
sudo mount -t tmpfs tmpfs $GAMING_CHROOT/tmp
sudo chmod 1777 $GAMING_CHROOT/proc $GAMING_CHROOT/sys $GAMING_CHROOT/dev $GAMING_CHROOT/dev/pts $GAMING_CHROOT/run $GAM
ING_CHROOT/run/user/1000 $GAMING_CHROOT/tmp
 sudo chroot $GAMING_CHROOT /bin/bash -x <<'EOF'
  source /root/.bashrc
   chmod 1777 /dev/shm
    su raezroth
     cd ~/
      PAN_MESA_DEBUG=gl3 steam -no-cef-sandbox +open steam://open/bigpicture 2> steam.log >> steam.log
      EOF
       sudo umount $GAMING_CHROOT/dev/pts $GAMING_CHROOT/run/user/1000 $GAMING_CHROOT/*">> /bin/start-steam.sh
	
	$root chmod +x /bin/start-steam.sh
	$root cp -r $GITDIR/scripts/steam.desktop /usr/share/applications/
	$root chmod +x /usr/share/applications/steam.desktop
	# Creates a helper script to get a standard terminal.
	$root echo "cd $GAMING_CHROOT
       
sudo mount -t proc /proc $GAMING_CHROOT/proc
sudo mount -t sysfs /sys $GAMING_CHROOT/sys
sudo mount --bind /dev $GAMING_CHROOT/dev
sudo mount -t devpts devpts $GAMING_CHROOT/dev/pts
sudo mount --bind /run $GAMING_CHROOT/run
sudo mount --bind /run/user/1000 $GAMING_CHROOT/run/user/1000
sudo mount -t tmpfs tmpfs $GAMING_CHROOT/tmp
sudo chmod 1777 $GAMING_CHROOT/proc $GAMING_CHROOT/sys $GAMING_CHROOT/dev $GAMING_CHROOT/dev/pts $GAMING_CHROOT/run $GAM
ING_CHROOT/run/user/1000 $GAMING_CHROOT/tmp
 sudo chroot $GAMING_CHROOT 
      sudo umount $GAMING_CHROOT/dev/pts $GAMING_CHROOT/run/user/1000 $GAMING_CHROOT/*" >> /bin/gaming_chroot_terminal.sh

  $root chmod +x /bin/gaming_chroot_terminal.sh

	echo "Umounting container..."

	$root umount $GAMING_CHROOT/dev/pts $GAMING_CHROOT/run/user/1000 $GAMING_CHROOT/*

	echo "Install Complete! If everything went well you should be able to launch Steam."

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
