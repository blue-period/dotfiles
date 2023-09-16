alias v="nvim"
alias fzf="fzf | pbcopy"
alias fzfd="find . -type d -print | fzf"

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
