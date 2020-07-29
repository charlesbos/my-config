#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

# Add ~/bin and ~/.local/bin (plus subdirs) to PATH
PATH=$PATH:$HOME/.local/bin:$HOME/bin
for x in $(ls ~/.local/bin); do 
  if [ -d $HOME/.local/bin/$x ]; then 
    PATH=$PATH:$HOME/.local/bin/$x
  fi
done
unset x
export PATH

# Use GTK2 theme and dialogues in Qt5 apps
export QT_QPA_PLATFORMTHEME=gtk2

# Start gnome-keyring
eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
export SSH_AUTH_SOCK
