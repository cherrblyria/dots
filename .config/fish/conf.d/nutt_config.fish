# ENV
set -Ux GOPATH "$HOME/.go"

# PATH
fish_add_path \
    "$HOME/.local/bin" \
    "$HOME/.go/bin" \
    "$HOME/.cargo/bin" \
    "$HOME/nutty/.spicetify"

# Core shortcuts
alias please sudo
alias pls sudo

# Programs shortcuts
alias gte gnome-text-editor
alias zed zeditor
alias v nvim
alias gem gemini

# Dev
alias c cargo
alias cr 'cargo run'
alias cb 'cargo build'
alias ct 'cargo test'
alias ccb 'cargo clean'

# Dotfile
alias dot "git --git-dir $HOME/.dotfiles/ --work-tree $HOME"
alias ldot "dot config status.showUntrackedFiles false && lazygit --git-dir $HOME/.dotfiles/ --work-tree $HOME && dot config status.showUntrackedFiles true"

# Grep
alias rg 'rg --color=always'
alias grep 'grep --color=auto'

# LS family
alias ls 'eza --group-directories-first --icons'
alias l 'ls -lAh'
alias la 'ls -Ah'
abbr --add te 'ls -T --level=2'
abbr --add tea 'ls -AhT --level=2'

# Yazi
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

if status is-interactive
    if command -v zoxide >/dev/null
        zoxide init fish | source
    end

    if command -v starship >/dev/null
        source (starship init fish --print-full-init | psub)
    end

    if command -v thefuck >/dev/null
        thefuck --alias | source
    end
end
