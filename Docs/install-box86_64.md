
##Installing Box86 & Box64.

There are 2 ways we can go about this.

------

####1. Download the precompiled debian packages from the guides Release page and install with apt.

Make `Downloads` folder we will need this when installing Steam as well.
```
mkdir ~/Downloads
```

Navigate to Dowloads folder
```
cd ~/Downloads
```

Use `wget` to fetch the debian packages.

`wget https://github.com/Raezroth/Linux-ARM-Gaming-Chroot/releases/download/publish/box86_0.2.4_armhf.deb` For Box86

`wget https://github.com/Raezroth/Linux-ARM-Gaming-Chroot/releases/download/publish/box64_0.1.6_arm64.deb` For Box64

Then from inside your `Downloads` folder use apt to install
```
sudo apt install ./box*.deb
```

If you are using `chroot` command or `systemd-nspawn` with the `-b` boot flag, you will have to copy the binfmt files to the host.

From host terminal run

```
sudo cp -r CHROOT-PATH/etc/binfmt.d/box* /etc/binfmt.d/
```
Then restart the host's systemd-binfmt

```
sudo systemctl restart systemd-binfmt
```

Now Box86 and/or Box64 should start automatically when launching x86 or x86_64 binaries. 

-----

####2. Manually compile and install.

For Box86, copy the latest source for box86  and then compile it.

```
git clone https://github.com/ptitSeb/box86
```

For PinePhone (A64)

```
cd ~/box86; mkdir build; cd build; cmake ../ -DA64=1; make -j$(nproc); sudo make install
```

For PinePhone Pro (RK3399s)

```
cd ~/box86; mkdir build; cd build; cmake ../ -DRK3399=1; make -j$(nproc); sudo make install
.
```

For Box64, copy the latest source for box64 and compile it

git clone box64 source

```
git clone https://github.com/ptitSeb/box64
```

Before we compile we need to install the arm64 version of `gcc` with `sudo apt install gcc:arm64`

For PinePhone (A64)

```
cd ~/box64*; mkdir build; cd build; cmake ../ -DA64=1; make -j$(nproc); sudo make install
```

For PinePhone Pro (RK3399s)

```
cd ~/box64*; mkdir build; cd build; cmake ../ -DRK3399=1; make -j$(nproc); sudo make install
```

Now Box86/64 should be usuable. Updating will require reinstalling `gcc:armhf` for box86 and `gcc:arm64` for box64 to recompile.

------

If everything went well, you are now ready to move on to to installing Steam.

You can run `box86` or `box64` to see a list of environment variables or goto [Edit link in](). 

-----

[< Setting up your user](create-user.md) | [Installing Steam >](install-steam.md)


