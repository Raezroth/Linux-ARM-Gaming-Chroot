cd /home/alarm/.local/share/games/gaming_chroot/
doas chmod 1777 /dev/shm
doas mount -t proc /proc proc/
doas mount -t sysfs /sys sys/
doas mount --bind /dev dev/
doas mount -t devpts devpts dev/pts
doas mount --bind /run run/
doas mount --bind /run/user/1000 run/user/1000
doas mount -t tmpfs tmpfs tmp/
  #TODO there may be a better way to do this but for now its needed to make internet work reliably, maybe a symlink
doas cp /etc/resolv.conf etc/resolv.conf
