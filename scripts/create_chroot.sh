#
# Begin by creating a directory for the chroot (/chroot/debian_gaming), installing debootstrap,
# and creating a bootstrapped Debian Bookworm installation
#
echo -n "Please input the path you want the chroot to install to (eg. /home/alarm/.local/games): "
read CHROOT_PATH

mkdir $CHROOT_PATH
pacman -S debootstrap debian-archive-keyring xorg-xhost
debootstrap --arch armhf --components=main,universe sid /$CHROOT_PATH/debian_gaming https://deb.debian.org/debian

#
# Bind mount necessary directories /dev, /dev/pts, /proc, and /sys into the chroot
#
cd /$CHROOT_PATH/debian_gaming
mount -o bind /dev dev/
mount -t devpts devpts dev/pts
mount -o bind /proc proc/
mount -o bind /sys sys/

#
# This section executes within the chroot itself
# Begins by setting up root's .bashrc to set environment variables
# Creates user 'user' with password 'password'
# Installs required dependencies, box86, box64, custom libraries, and Steam
#
chroot /$CHROOT_PATH/debian_gaming/ /bin/bash -x <<'EOF'
su -
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
apt install -y sudo vim make cmake git wget gnupg libx11-dev libgl-dev libvulkan-dev libtcmalloc-minimal4 libnm0 zenity chromium alsamixergui libsdl2-dev unzip libgles-dev firefox-esr:arm64 libx11-dev:arm64 libvulkan-dev:arm64 libsdl2-dev:arm64 libgl-dev:arm64 libc6-dev:arm64 libgles-dev:arm64
adduser --home /home/user --gecos "" --disabled-password user
echo "user:password" | chpasswd
usermod -g users user
adduser user sudo
su user -
cd ~/
mkdir Downloads
cd Downloads
wget https://github.com/Raezroth/Linux-ARM-Gaming-Chroot/releases/download/0.2.6%2F0.1.8/box64_0.1.8_sid_generic__arm64.deb
wget https://github.com/Raezroth/Linux-ARM-Gaming-Chroot/releases/download/0.2.6%2F0.1.8/box86_0.2.6_sid_generic_armhf.deb
wget http://ftp.debian.org/debian/pool/main/libi/libindicator/libindicator7_0.5.0-4_armhf.deb
wget http://ftp.debian.org/debian/pool/main/liba/libappindicator/libappindicator1_0.4.92-7_armhf.deb
exit
apt install -y /home/user/Downloads/*.deb
su user -
cd ~/Downloads
wget https://repo.steampowered.com/steam/archive/stable/steam_latest.deb
exit
apt install -y /home/user/Downloads/steam_latest.deb
EOF

#
# Copy binfmt files from chroot to host
#
cp /$CHROOT_PATH/debian_gaming/etc/binfmt.d/box86.conf /etc/binfmt.d
cp /$CHROOT_PATH/debian_gaming/etc/binfmt.d/box64.conf /etc/binfmt.d
systemctl restart systemd-binfmt

echo "CHROOT_PATH=$CHROOT_PATH" > start_chroot.sh 
cat ./start_chroot_tmp.sh >> start_chroot.sh

# creates an uninstall script with the new path
echo "CHROOT_PATH=$CHROOT_PATH" > ./uninstall_chroot.sh
cat ./uninstall_chroot_tmp.sh >> ./uninstall_chroot.sh
