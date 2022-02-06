### To open a specific steam game, to get $STEAMAPPID go to [SteamDB](https://steamdb.info/apps/)
```
steam +open steam://rungameid/$STEAMAPPID
```

Note: when launching a game this way, Steam will be mimized and almost impossible to bring back up.

### Adjusting audio
Since the chroot container has a seperater audio server, you can use `alsamixergui` or `alsamixer` to adjust the audio level.

Look for the DAC outputs


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


### To improve performance

1. Set Steam Library setting to Low Bandwisth Mode and Low Performance Mode
2. Disable Broadcasting
3. Disable Remote Play, This is broken anyways.
4. If you do use a skin, be careful, Some tax Steam's Interface.
5. Launch with:

For Pinephone (A64): `BOX86_LOG=0 BOX64_LOG=0 steam +open steam://open/minigameslist 2> tee ~/steam.log`

For Pinephone Pro (RK3399s): `BOX86_LOG=0 BOX64_LOG=0 MESA_GL_VERSION_OVERRIDE=3.2 PAN_MESA_DEBUG=gl3 steam +open steam://open/minigameslist 2> tee steam.log`

This will redirect output to a file, which Improves performance a bit.

Note: I left the override for opengl 3 in there because it doesn't hurt anything, yet makes more games able to launch from library list.

6. Run all games on low obviously, many of games crash loading in from menus due to texture overloading.
 

### NOTE: Touchscreen Controller input is experimental use at your own risk.

For Toucscreen Controller use [TabPad](https://github.com/nitg16/TabPad) must be ran from a seperate terminal.

Recommend to launch another terminal and chroot into the container again for this. You can try to run this from the host, but TabPad relies on X11 and won't launch with wayland currently, Looking into modifying or just a new touchscreen controller.

-------

[< Using Wine](using-wine.md) | [Uninstalling the container >](delete-chroot.md)

