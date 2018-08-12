#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

# Add ~/.local/bin (plus some symlinked git repos) to PATH
PATH=$PATH:~/.local/bin:~/.local/bin/my-scripts:~/.local/bin/mwmmenu

# Use GTK2 theme and dialogues in Qt5 apps
export QT_QPA_PLATFORMTHEME=gtk2

# Start gnome-keyring
eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
export SSH_AUTH_SOCK
