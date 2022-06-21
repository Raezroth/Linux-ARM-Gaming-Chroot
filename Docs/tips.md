### To open a specific steam game, to get $STEAMAPPID go to [SteamDB](https://steamdb.info/apps/)
```
steam +open steam://rungameid/$STEAMAPPID
```

Note: when launching a game this way, Steam will be mimized and almost impossible to bring back up.

### Adjusting audio
Since the chroot container has a seperater audio server, you can use `alsamixergui` or `alsamixer` to adjust the audio level.

Look for the DAC1 & DAC2 outputs


### Managing tasks.

You will probably end up having to manage tasks of crashed programs and such. 

You can easily:

1. Kill the task with htop; Must have htop installed

or

2. Use `ps ax` the display a list of runnning tasks then find the PID for Steam.

   Example:
   ```
   [your_user@your_hostname ~]$ ps a 
    PID TTY      STAT   TIME COMMAND
    835 tty1     Ssl+   0:09 /usr/lib/Xorg -nolisten tcp -background none -seat seat0 vt1 -auth /var/run/sddm/{ce2a345f
   1797 pts/2    Ss     0:00 /bin/bash
   2501 pts/2    S+     0:00 sudo .xs/backs/.applications/OpenRGB/openrgb --gui

   ```

   Then use `kill -9 PID` to kill the process.

### Using `systemd-nspawn`

`systemd-nspawn` can be used on any system that uses systemd.
As stated in the beginning, `systemd-nspawn` can be used to auto mount and auto start the container. You can do so by using:

```
sudo systemd-nspawn -D chroot-path/container-name
```

It can be used in a combination of other flags for GUI and even running daemons in the container.

To run X11 gui apps use `--setenv=DISPLAY=:1 --bind-ro=/tmp/.11-unix` like so:

```
sudo systemd-nspawn --setenv=DISPLAY=:1 --bind-ro=/tmp/.11-unix -D chroot-path/container-name
```

To enable daemons with nspawn use the `-b` flag. This will also allow Desktop environments to run. You with have to use the `poweroff` command to close the container. It can be used like so:

```
sudo systemd-nspawn --setenv=DISPLAY=:1 --bind-ro=/tmp/.11-unix -bD chroot-path/container-name 
```


### To improve performance

1. Set Steam Library setting to Low Bandwisth Mode and Low Performance Mode
2. Disable Broadcasting, This is broken anyways.
3. If you do use a skin, be careful, Some tax Steam's Interface.
4. Launch with:

For Pinephone (A64): `BOX86_LOG=0 BOX64_LOG=0 steam +open steam://open/minigameslist 2> tee ~/steam.log`

For Pinephone Pro (RK3399s): `BOX86_LOG=0 BOX64_LOG=0 MESA_GL_VERSION_OVERRIDE=3.2 PAN_MESA_DEBUG=gl3 steam +open steam://open/minigameslist 2> tee steam.log`

This will redirect output to a file, which Improves performance a bit.

Note: I left the override for opengl 3 in there because it doesn't hurt anything, yet makes more games able to launch from library list.

6. Run all games on low obviously, many of games crash loading in from menus due to texture overloading.

### Dealing with thermal throttling

This is for the PinePhones currently. Alot of SBC (single board computers) have different types of coolers available for them.

So far, the best way to deal with lag from thermal throttling is to strap a cooler of some sort to it.
A few of the users in the Pine64 Pinephone chat (you can find links [here](https://wiki.pine64.org/index.php/Main_Page)) have had some interesting ideas about cooling solutions. 
People have used a variety of methods, such as TEC cooling, a ENOKAY Raspberry Pi cooler, Desktop Heatsinks, to even sticking the device in the freezer.
It is best to stick the heatsinks on the modem shielding, due to design. This is not a optimal way to draw heat from the CPU during gaming, especially since it passes through the modem, but it does alright and proven to show stability in some games.

A couple of users are designing their own mock cooling cases. I will release details of my own mock case when I have a prototype.

### NOTE: Touchscreen Controller input is experimental use at your own risk.

Steam Remote Play has a touchpad that can be enabled, but it only works in Remote Play.  

For Toucscreen Controller use in other programs [TabPad](https://github.com/nitg16/TabPad) must be used from `systemd-nspawn -b` for best possible usage.

Recommend to launch another terminal and chroot into the container again for this. You can try to run this from the host, but TabPad relies on X11 and won't launch with wayland currently, Looking into modifying or just a new touchscreen controller.


### Lzdoom Gamepad

There is a hacked together gamepad for lzdoom using wvkbd, the link can be found here with more information: [DOOM-wvkbd](https://github.com/Laar3/DOOM-wvkbd).

<img src="https://raw.githubusercontent.com/Laar3/DOOM-wvkbd/master/doom.png" width="175"/>


-------

[< Using Wine](using-wine.md) | [Uninstalling the container >](delete-chroot.md)
