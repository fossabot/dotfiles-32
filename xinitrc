#!/bin/sh

# Executed by startx (run your window manager from here)

XRESOURCES=$HOME/.Xresources
export LANG=en_US.utf8

# quiet version of which
_which(){
    which >/dev/null 2>&1
}

# (run if exists)
# simplifies running which checks on startup commands
_rie(){
    _which $1 && $*
}

# Scripts and services to start just after X11
[ -r $XRESOURCES ] && xrdb -merge $XRESOURCES
_rie nvidia-settings -a InitialPixmapPlacement=2
_which xscreensaver && _rie xss-lock -- xscreensaver-command -lock
[ -x $HOME/.screenlayout/default.sh ] && $HOME/.screenlayout/default.sh

setxkbmap -option caps:escape

if [ -d /etc/X11/xinit/xinitrc.d ]; then
    for f in /etc/X11/xinit/xinitrc.d/*; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

# exec gnome-session
# exec startkde
# exec startxfce4
# exec wmaker
# exec icewm
# exec blackbox
# exec fluxbox
# exec openbox-session
# ...or the Window Manager of your choice

if [ -n "$1" ]
then
    [ -n "$(which $1)" ] && exec $1
else
    exec i3
fi
