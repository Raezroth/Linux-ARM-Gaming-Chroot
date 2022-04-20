
##Installing Steam

--------

We are going to have to grab a few packages to install Steam.

First navigate to your downloads folder.

```
cd ~/Downloads
```
Use these next `wget` commands to fetch some libraries packages required by Steam.

```
wget http://ftp.debian.org/debian/pool/main/libi/libindicator/libindicator7_0.5.0-4_armhf.deb

wget http://ftp.debian.org/debian/pool/main/liba/libappindicator/libappindicator1_0.4.92-7_armhf.deb
```

Now install the library packages

```
sudo apt install ./lib*
```

Next, we fetch Steam's debian package.

```
wget https://repo.steampowered.com/steam/archive/stable/steam_latest.deb
```

Then install it.

```
sudo apt install ./steam_latest.deb
```

After installing navigate back to your `home` folder

```
cd ~/
```
------

If everything went well you can move on to using Steam.

------

[< Installing Box86 & Box64](install-box86_64) | [Using Steam >](using-steam.md)


