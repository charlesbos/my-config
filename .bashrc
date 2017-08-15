#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

#Disable flow control
stty -ixon

#My aliases
alias pkgcount='pacman -Q | wc -l'
alias reset='reset -Q'

#My functions
psrch() { 
  ps aux | grep -i $1 | grep -v grep
}

mp3count() {
  if [ "$1" ] && [ -d "$1" ]; then
    find "$1" -type f -name "*.mp3" | wc -l
  else
    find . -type f -name "*.mp3" | wc -l
  fi
}

to-mp3() {
  if [ "$1" ] && [ -d "$1" ]; then
    path="$1"
  else
    path="$PWD"
  fi
  if [ -f "$path/track00.cdda.wav" ]; then
    rm "$path/track00.cdda.wav"
  fi
  for x in $(ls "$path" | grep ".wav"); do 
    lame "$path/$x" -b 320 --cbr
    rm "$path/$x"
  done
  unset path
}

um() {
  if [ ! $1 ] || [ ! -b $1 ]; then
    echo "No device specified"
    return
  fi
  udisksctl unmount -b $1
}

umap() {
  if [ ! $1 ] || [ ! -b $1 ]; then
    echo "No device specified"
    return
  fi
  udisksctl unmount -b $1
  sleep 1
  udisksctl power-off -b $1
}

mt() {
  if [ ! $1 ] || [ ! -b $1 ]; then
    echo "No device specified"
    return
  fi
  udisksctl mount -b $1
}

setperms() {
  if [ ! "$1" ] || [ ! -d "$1" ]; then
    echo "Invalid directory"
    return
  fi
  perm_level=644
  if [ "$2" ] && [[ "$2" =~ ^[0-9]+$ ]]; then
    perm_level="$2"
  fi
  find "$1" -type f -exec chmod "$perm_level" {} \;
  unset perm_level
}

copyconfigs() {
  sync_files=('.bash_profile' '.bashrc' '.config/gtk-3.0/gtk.css' 
              '.config/gtk-3.0/settings.ini' '.fvwm' '.gtkrc-2.0' '.gvimrc' 
              '.vimrc' '.xinitrc' '.Xresources')
  for x in ${sync_files[@]}; do
    if [ "$(diff -Nurq $HOME/Devel/GitHub/my-config/$x $HOME/$x)" ]; then
      if [ "$1" ] && [ "$1" == "check" ]; then
        echo "Changed: $HOME/$x"
      else
        echo "Copying: $HOME/$x"
        if [ -f "$x" ]; then 
          cp -r "$HOME/$x" "$HOME/Devel/GitHub/my-config/$x"
        else
          rm -r "$HOME/Devel/GitHub/my-config/$x"
          cp -r "$HOME/$x" "$HOME/Devel/GitHub/my-config"
        fi
      fi
    fi
  done
  unset sync_files
}
