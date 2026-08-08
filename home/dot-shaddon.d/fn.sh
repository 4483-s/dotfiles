j() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  IFS= read -r -d '' cwd <"$tmp"
  [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
  /bin/rm -f -- "$tmp"
}
f() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  EDITOR=fxdisown yazi "$@" --cwd-file="$tmp"
  IFS= read -r -d '' cwd <"$tmp"
  [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
  /bin/rm -f -- "$tmp"
}
rm() {
  for i in "${@}"; do
    trash-put "${i}"
  done
  unset i
}
# function cd() {
#   new_directory="$*"
#   if [ $# -eq 0 ]; then
#     new_directory=${HOME}
#   fi
#   builtin cd "${new_directory}" && ls -lhF --time-style=long-iso --color=auto
# }

# vssh() {
#   local s
#   [[ $# -ge 2 ]] && s="$1@192.168.122.$2" || s="192.168.122.$1"
#   ssh-copy-id "$s"
#   ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "$s"
# }
vs() {
  local base='192.168.122.' f
  [[ $# -ge 2 ]] && f="$1@$base$2" || f="root@$base$1"
  ssh-copy-id -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "$f" 2>/dev/null
  ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "$f" 2>/dev/null
}

function extract() {
  if [[ -f $1 ]]; then
    case "$1" in
    *.tar.bz2) tar xjvf "$1" ;;
    *.tar.gz) tar xzvf "$1" ;;
    *.tar.xz) tar xvf "$1" ;;
    *.bz2) bzip2 -d "$1" ;;
    *.rar) unrar2dir "$1" ;;
    *.gz) gunzip "$1" ;;
    *.tar) tar xf "$1" ;;
    *.tbz2) tar xjf "$1" ;;
    *.tgz) tar xzf "$1" ;;
    *.zip) unzip2dir "$1" ;;
    *.Z) uncompress "$1" ;;
    *.7z) 7z x "$1" ;;
    *.ace) unace x "$1" ;;
    *) echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}
function pacl() {
  pacman -Ql "$@" | grep -v '/$'
}
