#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

# Add ~/.local/bin (plus subdirs) to PATH
PATH=$PATH:~/.local/bin
for x in $(ls ~/.local/bin); do 
  if [ -d ~/.local/bin/$x ]; then 
    PATH=$PATH:~/.local/bin/$x
  fi
done

# Use GTK2 theme and dialogues in Qt5 apps
export QT_QPA_PLATFORMTHEME=gtk2

# Start gnome-keyring
eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
export SSH_AUTH_SOCK
