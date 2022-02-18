cd /chroot/debian_gaming
sudo mount -o bind /dev dev/
sudo mount -o bind /dev/pts dev/pts
sudo mount -o bind /proc proc/
sudo mount -o bind /sys sys/
xhost +local:
sudo chmod 177 /dev/shm
sudo chroot .
