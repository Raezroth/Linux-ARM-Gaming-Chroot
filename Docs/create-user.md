
###Setting up your user

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

If everything went well we can change to our user and install Box86 and Box64.

---

[< Setting up the container] (Doc/create-chroot.md) | [Installng Box86/Box64 >] (Docs/install-box86_64.md)

