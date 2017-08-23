#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

# Add my-scripts to PATH
PATH=$PATH:~/Devel/GitHub/my-scripts

# Add mwmmenu to PATH
PATH=$PATH:~/Devel/GitHub/mwmmenu

# Use GTK2 theme and dialogues in Qt5 apps
export QT_QPA_PLATFORMTHEME=gtk2
