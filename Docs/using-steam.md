## Using Steam

Remember that  `sudo chmod 1777 /dev/shm` needs to be ran before running Steam, This will only have to be done after every device reboot.

Note: Steam runs best in `minigameslist`. You can use steam skins just be care due to some are taxing. Proton does not work but controller does work in some games, though isn't configurable.

If you are only using Box86, this command will set the architecture to linux32 to use 32bit libraries only. This is so Steam doesn't register 64bit.

```
setarch -L linux32 steam +open steam://open/minigameslist
```

If you have both Box86 & Box64, just launch this and it will register 64bit

```
steam +open steam://open/minigameslist
```

If you are running the PinePhone Pro, you may need to force OpenGL 3. You can do this by forcing mesa and panfrost to gl3. Just launch Steam with these variables or put the variables in your root's bashrc.

```
MESA_GL_VERSION_OVERRIDE=3.2 PAN_MESA_DEBUG=gl3 steam +open steam://open/minigameslist
```
I set it to force OpenGL 3.2 so games like TableTop Simulator and Borderlands PreSequel launch.

If all went well in the previous steps, Steam should launch and you should be able to login and download a game within your system's specification range. =)

--

## More Usage

You can automatically start Big Picture with:
```
BOX86_LOG=0 BOX64_LOG=0 steam +open steam://open/bigpicture
```


This may still be needed for some people to use Remote Play. `BOX64_EMULATED_LIBS=libSDL2-2.0.so.0`

--------

### To uninistall games:

Use Big Picture Mode or manual uninstall down below.

1. Close Steam
2. Grab `APPID` from [SteamDB](https://steamdb.info/apps/)
3. Delete game from `PATH_TO_STEAMLIBRARY/common/`
4. Delete `appmanifest_APPID.acf` from `PATH_TO_STEAMLIBRARY/`
5. Launch Steam again and the game should be uninstalled.

-----

[< Installing Steam](install-steam.md) | [Installing Wine >](install-wine.md)


 
