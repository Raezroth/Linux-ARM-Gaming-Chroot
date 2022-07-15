
## Installing Box86 & Box64.

There are 2 ways we can go about this.

------

#### 1. Download the precompiled debian packages from the repos.

You can use @Itai-Nelken's apt repository to install precompiled box86 debs, updated weekly.

```
sudo wget https://itai-nelken.github.io/weekly-box86-debs/debian/box86.list -O /etc/apt/sources.list.d/box86.list
wget -qO- https://itai-nelken.github.io/weekly-box86-debs/debian/KEY.gpg | sudo apt-key add -
sudo apt update && sudo apt install box86 -y
```
You can use @ryanfortner's apt repository to install precompiled box64 debs, updated every 24 hours.

```
sudo wget https://ryanfortner.github.io/box64-debs/box64.list -O /etc/apt/sources.list.d/box64.list
wget -O- https://ryanfortner.github.io/box64-debs/KEY.gpg | gpg --dearmor | sudo tee /usr/share/keyrings/box64-debs-archive-keyring.gpg 
sudo apt update && sudo apt install box64 -y
```


If you are using `chroot` command or `systemd-nspawn` without the `-b` boot flag, you will have to copy the binfmt files to the host.

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

#### 2. Manually compile and install.

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
```

For Box64, copy the latest source for box64 and compile it

git clone box64 source

```
git clone https://github.com/ptitSeb/box64
```

Before we compile we need to install the arm64 version of `gcc` with `sudo apt install gcc:arm64`

For PinePhone (A64)

```
cd ~/box64; mkdir build; cd build; cmake ../ -DA64=1; make -j$(nproc); sudo make install
```

For PinePhone Pro (RK3399s)

```
cd ~/box64; mkdir build; cd build; cmake ../ -DRK3399=1; make -j$(nproc); sudo make install
```

Now Box86/64 should be usuable. Updating will require reinstalling `gcc:armhf` for box86 and `gcc:arm64` for box64 to recompile.

------

If everything went well, you are now ready to move on to to installing Steam.

You can run `box86` or `box64` to see a list of environment variables or goto [Box86](https://github.com/ptitSeb/box86/blob/master/docs/USAGE.md), [Box64](https://github.com/ptitSeb/box64/blob/main/docs/USAGE.md). 

-----

[< Setting up your user](create-user.md) | [Installing Steam >](install-steam.md)


