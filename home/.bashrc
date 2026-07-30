#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
# PS1="[\[\033[0;32m\]\u@\h:\w \[\033[0m\]\[\033[0;31m\]]$ \[\033[0m\]"

#PS1="[ \[\033[32;1m\]\u@\h:\w\[\033[0m\] ]\[\033[36m\] $ \[\033[0m\]" # colored prompt
#PS1="\[\033[32;1m\]\u@\h:\w\[\033[0m\] \[\033[36m\]$ \[\033[0m\]" # colored prompt without brackets
PS1='\[\033[32;1m\]\u@\h:\w\[\033[0m\] $? \[\033[36m\]$ \[\033[0m\]' # play
export HISTTIMEFORMAT='%Y-%m-%d %H:%m:%d	'
shopt -s globstar
for i in ~/.shaddon.d/*; do
  . "$i"
done
#bind 'TAB:menu-complete'
#bind 'set show-all-if-ambiguous on'
#export PAGER='most'
