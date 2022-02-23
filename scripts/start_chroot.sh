cd /chroot/debian_gaming
sudo mount -o bind /dev dev/
sudo mount -t devpts devpts dev/pts
sudo mount -o bind /proc proc/
sudo mount -o bind /sys sys/
xhost +local:
sudo chroot .
