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
alias cp='cp --preserve'
alias mksrcinfo='makepkg --printsrcinfo > .SRCINFO'

#My functions
psrch() { 
  ps aux | grep -i $1 | grep -v grep
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

getkey() {
  xmodmap -pk | tr -d "\t" | tr -s " " | awk -F " " '{if ($3 != "" && $1 ~ /^[0-9]+$/ ) {print $1" "$3}}' | sed 's@(@@g;s@).*$@@g' | grep "^$1 " | cut -d " " -f 2
}

findtext() {
  if [ "$1" ] && [ -d "$1" ]; then 
    target="$1"
  else
    if [ "$1" ]; then
      echo Invalid directory: "$1"
      return 1
    fi
    target="$PWD"
  fi
  for x in $(find "$target" -type f); do
    if [ ! "$(file -i "$x" | grep charset=binary)" ]; then
      echo "$x"
    fi
  done
  unset target
}

mygrep() {
  grep -Rn "$@" --color=always | grep -v "\.svn\|\.git\|\.Po\|Binary file\|.html\|.mod\|.info\|.log\|.xml\|gtest"
}

tbird-backup() {
  if [ -f "/mnt/c/Windows/System32/cmd.exe" ]; then
    tbpath="$(echo $(wslpath -a $(/mnt/c/Windows/System32/cmd.exe /c echo %userprofile% 2>/dev/null)) | sed "s/\r//g")/AppData/Roaming"
    tbname="Thunderbird"
  else
    tbpath="$HOME"
    tbname=".thunderbird"
  fi
  pushd "$tbpath" > /dev/null
  zip -q -0 -r "$OLDPWD/thunderbird-backup-$(date +%Y%m%d).zip" "$tbname"
  popd > /dev/null
  unset tbpath tbname
}

firefox-backup() {
  if [ -f "/mnt/c/Windows/System32/cmd.exe" ]; then
    ffpath="$(echo $(wslpath -a $(/mnt/c/Windows/System32/cmd.exe /c echo %userprofile% 2>/dev/null)) | sed "s/\r//g")/AppData/Roaming"
    ffname="Mozilla"
  else
    ffpath="$HOME"
    ffname=".mozilla"
  fi
  pushd "$ffpath" > /dev/null
  zip -q -0 -r "$OLDPWD/firefox-backup-$(date +%Y%m%d).zip" "$ffname"
  popd > /dev/null
  unset ffpath ffname
}
