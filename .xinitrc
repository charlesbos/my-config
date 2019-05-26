#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

# Set 1366x768 because 1080p on a laptop screen makes everything far too small

sname=$(xrandr | grep "connected primary" | cut -d " " -f 1)
modeline=$(cvt 1366 768 60 | tail -n 1 | cut -d " " -f 2-)
mode=$(echo $modeline | cut -d " " -f 1)
xrandr --newmode $modeline
xrandr --addmode $sname $mode
xrandr --output $sname --mode $mode --auto
unset sname modeline mode

# start wm

exec startfluxbox
