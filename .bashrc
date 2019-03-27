#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PS1='[\u@\h \W]\$ '

#My aliases
alias ls='ls --color=auto -h'
alias pkgcount='pacman -Q | wc -l'
alias pkglist='pacman -Qeq > pacmanqeq-$(date "+%Y%m%d")'
alias reset='reset -Q'
alias tree='tree -C'
alias less='less -M'
alias grep='grep --color=auto'
alias du='du -h'
alias df='df -h'
alias cp='cp --preserve'
alias mksrcinfo='makepkg --printsrcinfo > .SRCINFO'
alias mpg123='mpg123 -b 2048 -v'

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
  unset path x
}

um() {
  if [ ! $1 ] || [ ! -b $1 ]; then
    echo "No device specified"
    return 1
  fi
  udisksctl unmount -b $1
}

umap() {
  if [ ! $1 ] || [ ! -b $1 ]; then
    echo "No device specified"
    return 1
  fi
  udisksctl unmount -b $1
  sleep 1
  udisksctl power-off -b $1
}

mt() {
  if [ ! $1 ] || [ ! -b $1 ]; then
    echo "No device specified"
    return 1
  fi
  udisksctl mount -b $1
}

copyconfigs() {
  sync_files=('.bash_profile' '.bashrc' '.compton.conf' 
              '.config/gtk-3.0/gtk.css' '.config/gtk-3.0/settings.ini' 
              '.config/mpv' '.gtkrc-2.0' '.vimrc' '.xinitrc' '.Xresources')
  for x in ${sync_files[@]}; do
    if [ "$(diff -Nurq $HOME/Devel/GitHub/my-config/$x $HOME/$x)" ]; then
      if [ "$1" ] && [ "$1" == "check" ]; then
        echo "Changed: $HOME/$x"
      elif [ "$1" ] && [ "$1" == "display" ]; then
        echo "Changed: $HOME/$x"
        diff -Nur "$HOME/Devel/GitHub/my-config/$x" "$HOME/$x"
      else
        echo "Copying: $HOME/$x"
        if [ ! -d "$HOME/Devel/GitHub/my-config/$(dirname $x)" ]; then
          mkdir -p "$HOME/Devel/GitHub/my-config/$(dirname $x)"
        fi
        rm -rf "$HOME/Devel/GitHub/my-config/$x"
        cp -r "$HOME/$x" "$HOME/Devel/GitHub/my-config/$x"
      fi
    fi
  done
  unset sync_files x
}

backup-tar() {
  dstamp=$(date "+%Y-%m-%d")
  need_sudo=0
  top=~
  case $1 in
    mail)
      backup_files=('.thunderbird')
      name='thunderbird'
      ;;
    auth)
      backup_files=('.ssh' '.local/share/keyrings')
      name='auth'
      ;;
    netctl)
      backup_files=('etc/netctl')
      name='netctl'
      need_sudo=1
      top=/
      ;;
    web)
      backup_files=('.chromium')
      name='chromium'
      ;;
    *)
      ;;
  esac
  if [ ${backup_files} ]; then
    if [ ${need_sudo} == 0 ]; then
      tar -C ${top} -cf ${name}-backup-${dstamp}.tar ${backup_files[@]}
    else
      sudo tar -C ${top} -cf ${name}-backup-${dstamp}.tar ${backup_files[@]}
      sudo chown ${USER}:${USER} ${name}-backup-${dstamp}.tar
    fi
  fi
  unset dstamp backup_files name need_sudo top
}

dircount() {
  if [ "$1" ] && [ -d "$1" ]; then 
    target="$1"
  else
    if [ "$1" ]; then
      echo Invalid directory: "$1"
      return 1
    fi
    target="$PWD"
  fi
  expr $(ls -a "$target" | wc -l) - 2
  unset target
}

batstatus() {
  for x in $(ls /sys/class/power_supply | grep BAT); do
    bat_status=$(cat /sys/class/power_supply/${x}/status)
    cur_charge=$(cat /sys/class/power_supply/${x}/charge_now)
    full_charge=$(cat /sys/class/power_supply/${x}/charge_full)
    charge=$(bc <<< "scale=2; ${cur_charge} / ${full_charge} * 100")
    echo Name=${x} : Status=${bat_status} : Charge=${charge/.*/}%
  done
  unset bat_status cur_charge full_charge charge x
}

nthash() {
  if [ ! "$1" ]; then
    return 1
  fi
  echo -n "$1" | iconv -t utf16le | openssl md4
}

wpahash() {
  if [ ! "$1" ] || [ ! "$2" ]; then
    echo "wpahash ESSID PASSWORD"
    return 1
  fi
  wpa_passphrase "$1" "$2" | grep psk | grep -v "^[[:blank:]]#psk=" | tr -d " " | cut -d "=" -f 2
}
