# Games that run on the Pinephone Pro

--------

Keep in mind that the Rockchip RK3399s' Mali-T860MP4 GPU only supports up to OpenGL 3.0, but can be tricked to use OpenGL 3.2.

This is also still ARM hardware. It is best to run on the lowest settings a game can run on.

See [Box86 Compatibility List](https://box86.org/app/) for others that might be compatible.

--------

### EMULATORS:

Mupen64Plus - ```Runs great, Needs to be compiled from source.```

VisualBoyAdvance - ```Runs Great```

MGBA - ```Runs Great, should be in repo for install with apt command```

---

### Ports:

OpenMW - ```Runs Great, should be in repo for install with apt command```

lzDoom - ```Runs Okay, Compile from source``` There is a wayland "gamepad" for this, see [Tips & Tricks](../Docs/tips.md) for more details

gzDoom - ```Runs Great, compile from source```

--------

## BOX86 

--------

### STEAM:

BattleBlock Theater - ```Runs Great```

Borderlands PreSequel (Linux Port) - ```Must use BOX86_LD_PRELOAD=/home/your_user/.local/share/Steam/steamapps/common/BorderlandsPreSequel/libiconv.so.2 MESA_GL_VERSION_OVERRIDE=3.2 PAN_MESA_DEBUG=gl3 to launch - Loads Slow and has Black textures```

Counter Strike - ```Runs great```

Counter Strike Source - ```Prone to crashes due to newer updates, Runs Well when plays. may take a couple of relaunches```

Day of Defeat - ```Runs Great```

Elder Scrolls V: Skyrim Special Edition - ``` Requires Low End Textures mod and disabling Anniversary upgrade. Ingame downloader crashes the game. Launch with MESA_GLSL_VERSION_OVERRIDE=150```  Skyrim Mods: [Low-End Textures - SE](https://www.nexusmods.com/skyrimspecialedition/mods/47479/)

Half-Life - ```Runs great```

Half-Life 2 - ```Kinda Broken due to libmimalloc Source Engine update for Steam Deck```

Left 4 Dead 2 - ```Kinda Broken due to libmimalloc Source Engine update for Steam Deck```

Don't Starve - ```Runs Well```

Don't Starve Together - ```Runs Well```

Minit - ```Plays Great```

Portal - ```Runs Well```

Portal 2 - ```Kinda Broken due to libmimalloc Source Engine update for Steam Deck```

Team Fortress Classic - ```Runs Great```

Team Fortress 2 - ```Kinda Broken due to libmimalloc Source Engine update for Steam Deck```

Terraria - ```Loads fine, runs slow. Looking into optimizations```

----

### GOG:

Undertale - ```Runs Great```

Super Meat Boy - ```Runs Well```

----

### Wine:

Fallout 1 - ```Runs Well``` 

Fallout 2 - ```Runs Well```

Fallout 3 GOTY - ```Runs Slow```

Fallout NV - ```Runs Slow```

------

## BOX64 - May or may not need this [revision](https://github.com/ptitSeb/box64/archive/fbb534917a028aaae2dd6b79900425dbe5617112.zip) for TableTop Simulator

------

### STEAM

---

TableTop Simulator - ```Must use MESA_GL_VERSION_OVERRIDE=3.2 PAN_MESA_DEBUG=gl3 to launch - Loads Slow, especially with 10+ workshop addons.```
 

### GOG

----

Super Meat Boy - ```Runs Well```



