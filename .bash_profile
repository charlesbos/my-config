#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

# Add ~/bin and ~/.local/bin (plus subdirs) to PATH
MYBINDIRS=($HOME/.local/bin $HOME/bin)
for x in ${MYBINDIRS[@]}; do
  if [ ! -d $x ]; then
    continue
  fi
  PATH=$PATH:$x
  for y in $(ls $x); do 
    if [ -d $x/$y ]; then 
      PATH=$PATH:$x/$y
    fi
  done
done
unset x y MYBINDIRS
export PATH

# Use GTK2 theme and dialogues in Qt5 apps
export QT_QPA_PLATFORMTHEME=gtk2
