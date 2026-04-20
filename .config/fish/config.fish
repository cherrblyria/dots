# ENV
set -Ux GOPATH "$HOME/.go"
set -Ux EDITOR code

# PATH
fish_add_path \
    "$HOME/.local/bin" \
    "$HOME/.go/bin" \
    "$HOME/.cargo/bin" \
    "$HOME/.spicetify"

# Core shortcuts
alias q exit
alias cls clear
alias pls sudo
alias please sudo

# Programs shortcuts
alias e code
alias c code
alias t tmux
alias oc opencode

function kw
    kwrite $argv &>/dev/null & disown
end

function y
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    if read -z cwd <"$tmp"; and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        # builtin cd -- "$cwd"
        z -- "$cwd"
        rm -f -- "$tmp"
    end
end

function yc
    set tmp (mktemp -t "yazi-chooser.XXXXXX")
    yazi $argv --chooser-file="$tmp"
    if test -s "$tmp"
        echo (cat "$tmp")
        rm -f -- "$tmp"
    end
end

# Git
alias lg lazygit
alias g git
alias ga 'git add'
alias gp 'git push'
alias gl 'git pull'
alias gc 'git checkout'
alias gb 'git branch'
alias gst 'git status'
alias gcm 'git commit -m'

# Python
alias py python

# Docker
alias dk docker
alias ldk lazydocker
alias dkc 'docker compose'
alias dkps 'docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Status}}"'

# Dotfile
alias dot "git --git-dir $HOME/.dots/ --work-tree $HOME"
alias ldot "dot config status.showUntrackedFiles false && lazygit --git-dir $HOME/.dots/ --work-tree $HOME && dot config status.showUntrackedFiles true"

# Search & Files
abbr --add ffind 'fd --type f'
abbr --add ff 'fd --type f | fzf'
alias f fzf
alias rg 'rg --color=always'
alias grep 'grep --color=auto'

alias b 'bat -Pp'
alias tch touch
alias mk touch
alias mkd mkdir

alias ... 'z ../..'
alias .... 'z ../../..'
alias ..... 'z ../../../..'

# LS family
alias ls 'eza --group-directories-first --icons'
alias l 'ls -lAh'
alias la 'ls -Ah'
abbr --add te 'ls -T --level=2'
abbr --add tea 'ls -AhT --level=2'

# System maintenance
abbr --add clnlog 'sudo journalctl --vacuum-time=7d'
abbr --add lpkg 'yay -Q | fzf -e'
abbr --add lupkg 'yay -Qet | fzf -e'
abbr --add clnpkg 'yay -Rns (yay -Qtdq)'
abbr --add rmpkg 'yay -Rns (yay -Qetq | fzf -e)'

abbr --add def 'find . -type f -empty -delete'
abbr --add ded 'find . -type d -empty -delete'
abbr --add dbl 'find . -xtype l -delete'

if status is-interactive
    set -g fish_greeting
    source (starship init fish --print-full-init | psub)
    zoxide init fish | source &
end

# opencode
fish_add_path /home/nutty/.opencode/bin
