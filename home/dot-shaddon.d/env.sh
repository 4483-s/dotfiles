export TERM=xterm-256color
export BROWSER='waterfox'
export EDITOR='nvim'

_pathhelper() {
  [[ :$PATH: == *:${1}:* ]] || export PATH="${1}:${PATH}"
}
_pathhelper "${HOME}/.local/bin"
_pathhelper "${HOME}/bin"
unset -f _pathhelper
# [[ :$PATH: == *:${HOME}/.local/bin:* ]] || export PATH=${HOME}/.local/bin:${PATH}
export MANPAGER='nvim +Man!'
# export AGNOSTER_DIR_BG=56
# export AGNOSTER_DIR_FG=193
