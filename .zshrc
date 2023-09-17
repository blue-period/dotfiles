alias v="nvim"
alias cat="bat"

fzf() { 
    #use bashes param substitution to get the last part of the path since you are already in the folder after cding
    command fzf --preview 'bat --theme=Nord --style=numbers --color=always --line-range :500 {}' | pbcopy
    file=$(pbpaste)
    if test -f "$file"; then
        dir=$(dirname $file)
        cd $dir
        relative=${file##*/} 
        nvim $relative
    fi

}

alias ls="exa"
alias ll="exa -alh"
alias tree="exa --tree"
export LS_COLORS="di=32:gm=43:fi=33"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/ramsddc1/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/ramsddc1/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/ramsddc1/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/ramsddc1/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

eval "$(zoxide init zsh)"
