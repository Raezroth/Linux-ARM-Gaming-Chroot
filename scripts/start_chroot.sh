cd /chroot/debian_gaming
sudo mount -o bind /dev dev/
sudo mount -t devpts devpts dev/pts
sudo mount -o bind /proc proc/
sudo mount -o bind /sys sys/
sudo mount -o bind /run run/
sudo mount -o bind /run/user/1000 run/user/1000
sudo mount -o bind /tmp tmp/
sudo chroot .
