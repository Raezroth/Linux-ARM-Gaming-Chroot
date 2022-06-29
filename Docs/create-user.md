
### Setting up your user

----

Note: Replace user1 with your preferred username when creatinging a user. 

```
adduser --home /home/user1 user1 
```

Next add user1 to users group

```
usermod -g users user1
```

These next commands set your passwords in combination with the corrisponding user.


```
passwd user1
```

Remember to set root to something complex. Also write it down.

```
passwd root
```

Next, add user1 to visudo

```
EDITOR=vim visudo
```

or use nano if you are new to linux

```
EDITOR=nano visudo
```


```
root  ALL=(ALL:ALL) ALL

user1  ALL=(ALL:ALL) ALL
```

---

Note: There is a bug where the home folder doesn't always get created. We must create one ourselves.

```
mkdir /home/user1
```

This creates the home directory

Then `chown` it to user1

```
chown user1 /home/user1
```

---

Set user wayland & x11 variables for graphical use.

`su user1`

`cd ~/`

`vim ./profile` or `nano .profile`

Add these export variables

```
export SDL_VIDEODRIVER=wayland

export WAYLAND_DISPLAY=wayland-1

export GDK_BACKEND=wayland

export XDG_SESSION_TYPE=wayland

export XDG_RUNTIME_DIR=/run/user/1000

export DISPLAY=:1

export XSOCKET=/tmp/.X11-unix/X1

export _JAVA_AWT_WM_NONREPARENTING=1
```

---

If everything went well we can install Box86 and Box64.

---

[< Setting up the container](create-chroot.md) | [Installng Box86/Box64 >](install-box86_64.md)

