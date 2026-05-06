# ENV
set -x GOPATH "$HOME/.go"
set -x EDITOR nvim

# PATH
fish_add_path \
    "$HOME/.local/bin" \
    "$HOME/.go/bin"

function gte
    gnome-text-editor -- "$argv" 2&>/dev/null & disown
end

# Safety
function r
    for arg in $argv
        gio trash $arg
    end
end

# Yazi
function y
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    if read -z cwd <"$tmp"; and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        # @fish-lsp-disable-next-line 7001
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

if status is-interactive
    # Core shortcuts
    alias q exit
    alias cls "clear && fastfetch"
    alias doas sudo
    alias pls sudo
    alias plz sudo
    alias please sudo

    # Programs shortcuts
    alias v nvim
    alias t tmux
    alias oc opencode

    # Git
    alias lg lazygit
    alias g git
    alias ga 'git add'
    alias gp 'git push'
    alias gl 'git pull'
    alias gb 'git branch'
    alias gst 'git status'
    alias gcm 'git commit -m'

    # LS family
    alias ls 'eza --group-directories-first --icons'
    alias l 'ls -lAh'
    alias la 'ls -Ah'
    abbr --add te 'ls -T --level=2'
    abbr --add tea 'ls -AhT --level=2'

    # Search & Files
    abbr --add ffind 'fd --type f'
    abbr --add ff 'fd --type f | fzf'
    alias f fzf
    alias rg 'rg --color=always'
    alias grep 'grep --color=auto'

    alias b 'bat -Pp --theme-dark base16'
    alias tch touch
    alias mk touch
    alias mkd mkdir

    alias ... 'z ../..'
    alias .... 'z ../../..'
    alias ..... 'z ../../../..'

    # Dotfile
    alias dot "git --git-dir $HOME/.dots/ --work-tree $HOME"
    alias ldot "dot config status.showUntrackedFiles false && lazygit --git-dir $HOME/.dots/ --work-tree $HOME && dot config status.showUntrackedFiles true"

    # System maintenance
    abbr --add updmirror 'sudo reflector --country Thailand,Singapore --latest 10 --sort rate --save /etc/pacman.d/mirrorlist && paru -Syy'
    abbr --add clnlog 'sudo journalctl --vacuum-time=7d'
    abbr --add lpkg 'paru -Q | fzf -e'
    abbr --add lupkg 'paru -Qet | fzf -e'
    abbr --add clnpkg 'paru -Rns (paru -Qtdq)'
    abbr --add rmpkg 'paru -Rns (paru -Qetq | fzf -e)'

    abbr --add clnt 'rm -rf ~/.local/share/Trash/files/*'
    abbr --add def 'find . -type f -empty -delete'
    abbr --add ded 'find . -type d -empty -delete'
    abbr --add dbl 'find . -xtype l -delete'

    # Init
    # kotofetch --border false --source true
    cls
    set -g fish_greeting
    source (/usr/sbin/starship init fish --print-full-init | psub)
    zoxide init fish | source
end
