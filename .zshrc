# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="darkblood"
# ZSH_THEME='bira'
ZSH_THEME='agnoster'
# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
#ZSH_THEME_RANDOM_CANDIDATES=( "darkblood")

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
 zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias gmo="gammastep -O 3900"
alias v="nvim"
alias rm="trash-put"
alias fx="firefox"
alias pshdt="bash ~/.config/scripts/pushconfig.sh"
alias plldt="bash ~/.config/scripts/getconfig.sh"
alias nrd='npm run dev'
alias gcl="git clone"
alias gc="git commit"
alias upgd='yay -Syu'
alias ins='yay -S'
alias sch='yay -Ss'
alias rmpg='yay -Rns'
alias upgrade='sudo pacman -Syu'
alias sync='sudo pacman -S'
alias search='pacman -Ss'
alias remove='sudo pacman -Rns'
# alias l='eza -lah'
alias dir="eza --color=always --git --no-filesize --icons=always --no-time --no-user --no-permissions"
#ls
alias ls="eza --icons"
alias l="eza -l --icons --git"
alias la="eza -lA --icons --git"
alias ltl="eza -Tl  --icons --git -L"
alias lt="eza -Tl --icons --git"
alias lta="eza -Tla --icons --git"
# alias lss="eza -l --git --no-filesize --icons=always --no-time --no-user --no-permissions"
# alias lsp="eza -l --git --no-filesize --icons=always --no-time --no-user"
# alias lsa="eza -lba --git --icons=always --total-size"

# alias j='yazi'
##############
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/nvm/init-nvm.sh
# source /usr/share/zsh/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh
export BROWSER='firefox'
export EDITOR='nvim'
export MANPAGER='nvim +Man!'
export DEFAULT_USER='h'
export AGNOSTER_DIR_BG=magenta
export PATH=${PATH}:~/.scripts

setopt hashexecutablesonly
function j() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}
# zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
# autoload bashcompinit && bashcompinit
# autoload -Uz compinit
# compinit
# # Note: -e lets you specify a dynamically generated value.
#
# # Override default for all listings
# # $LINES is the number of lines that fit on screen.
# zstyle -e ':autocomplete:*:*' list-lines 'reply=( $(( LINES / 5 )) )'
#
# # Override for recent path search only
# zstyle ':autocomplete:recent-paths:*' list-lines 7 
#
# # Override for history search only
# zstyle ':autocomplete:history-incremental-search-backward:*' list-lines 8
#
# # Override for history menu only
# zstyle ':autocomplete:history-search-backward:*' list-lines 2000
