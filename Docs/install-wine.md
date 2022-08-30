
## Installing Wine 

For those of you who don't know, Wine is a Windows Compatibility Layer for Linux/Unix. There is already an ARM package but it ONLY runs Windows ARM Programs. To get around this we can run Wine in Box86 and Box64.

### Setting up Wine x86_64 for both Box86 and Box64

From inside the chroot terminal as your user, download and extract [Wine-TKG's 6.17-r0](https://github.com/Frogging-Family/wine-tkg-git/releases/tag/6.17.r0.g5f19a815):

```
cd ~/Downloads
wget https://github.com/Frogging-Family/wine-tkg-git/releases/download/6.17.r0.g5f19a815/wine-tkg-staging-fsync-git-6.17.r0.g5f19a815-326-x86_64.pkg.tar.zst
mkdir TKG-6.17/ && cd TKG-6.17/
tar -xvf ../wine-tkg-staging-fsync-git-6.17.r0.g5f19a815-326-x86_64.pkg.tar.zst
cd ~/
mv ~/Downloads/TKG-6.17/ ~/
```



To add Wine to your `$PATH`:
```
echo 'PATH=$PATH:/home/$USER/TKG-6.17/usr/bin' >> ~/.profile
```



Now you can run wine with the `wine` or `wine64` command.


-----
### Original Instructions for installing Wine for Box86 can be found [here](https://github.com/ptitSeb/box86/blob/master/docs/X86WINE.md)

Note: Doing this may or may not break Steam. It's worth the risk to try in my opinion.

------------

[< Using Steam](using-steam.md) | [Using Wine >](using-wine.md)

