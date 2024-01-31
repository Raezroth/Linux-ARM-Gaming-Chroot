# Set up binfmt handling for box86 and box64
# Adapted from QEMU script here: https://wiki.alpinelinux.org/wiki/How_to_make_a_cross_architecture_chroot

#!/bin/bash

i386_magic="\x7fELF\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x03\x00"
i386_mask="\xff\xff\xff\xff\xff\xfe\xfe\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff"

x86_64_magic="\x7fELF\x02\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x3e\x00"
x86_64_mask="\xff\xff\xff\xff\xff\xfe\xfe\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff"

echo "Registering box86 and box64 binaries in binfmt misc"

if [ ! -d /proc/sys/fs/binfmt_misc ]; then
    modprobe binfmt_misc || eend $? || return 1
fi

if [ ! -f /proc/sys/fs/binfmt_misc/register ]; then
    mount -t binfmt_misc binfmt_misc /proc/sys/fs/binfmt_misc >/dev/null || eend $? || return 1
fi

for arch in i386; do
    interpreter="/usr/local/bin/box86"
    magic=$(eval echo \$${arch}_magic)
    mask=$(eval echo \$${arch}_mask)

    echo ":box86:M::$magic:$mask:$interpreter:OCF" > /proc/sys/fs/binfmt_misc/register
done

for arch in x86_64; do
    interpreter="/usr/local/bin/box64"
    magic=$(eval echo \$${arch}_magic)
    mask=$(eval echo \$${arch}_mask)

    echo ":box64:M::$magic:$mask:$interpreter:OCF" > /proc/sys/fs/binfmt_misc/register
done
