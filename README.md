

# Linux ARM Gaming Chroot

-------------------------
###### Written on the go with a PinePhone Pro w/ Keyboard using bash, git, & vim.
-------

## Automated install script!!
Inside the script folder the script can automatically install the chroot.
This currently still needs testing from more people than [@Laar3](https://github.com/Laar3) and myself just to iron out edge cases and its not currently guaranteed to work (it should do though).
The script is only tested currently on danctnix arch however it should work on mobian and ~~postmarketos~~(postmarketos is being worked on but im running into some issues).

To use automated script:

Clone the repo `git clone https://github.com/Raezroth/Linux-ARM-Gaming-Chroot.git`

Navigate to the repo `cd Linux-ARM-Gaming-Chroot`

Launch script with `./scripts/Gaming_Chroot_Installer_Posix.sh`

Make sure you enter the chroot's terminal after creation and set the root and your user passwords.
Run `gaming-chroot-terminal`, then from the chroot's root run `passwd root` for root, then `passwd your_user` for your user. 

You can also manually set it up using the index below. This is best if you want to understand how it is all setup.

Be sure to check out [Tips & Tricks](Docs/tips.md) either way

## Index.

1. [Brief Introduction](Docs/introduction.md)

2. [Setting up the container](Docs/create-chroot.md)

3. [Setting up your user](Docs/create-user.md)

4. [Installing Box86 & Box64](Docs/install-box86_64.md)

5. [Installing Steam](Docs/install-steam.md)

6. [Using Steam](Docs/using-steam.md)

7. [Installing Wine](Docs/install-wine.md)

8. [Using Wine](Docs/using-wine.md)

9. [Tips & Tricks](Docs/tips.md)

10. [Uninstalling the container](Docs/delete-chroot.md)

11. [Credits](Docs/credits.md)

----------------------------------------------------

### Check out ptitSeb's [Box86](https://github.com/ptitSeb/box86)/[Box64](https://github.com/ptitSeb/box64) githubs.

-------------------------------------------------------

To see Videos of games running, check out these links:

WARNING: Source engine games _may_ not work with Box86/64 due to new libmimalloc update on the Source Engine. 
Some devices vary, Gold Source works fine though.

1. [Half Life 2 Deathmatch and Half Life 2 on PinePhone Pro with Box86](https://www.youtube.com/watch?v=lAfEB0B14fw)

2. [PinePhone Pro running Portal 2 through Steam using Box86](https://www.youtube.com/watch?v=yPr0Aw3xZrA)



