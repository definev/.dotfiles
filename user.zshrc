export GOROOT=$(brew --prefix go)/libexec

export PATH="$GOPATH/bin:$PATH"
export PATH="/Users/daiduong/.rbenv/shims:$PATH"
export PATH="/Users/daiduong/.gem/bin:$PATH"
export PATH="/Users/daiduong/Library/Android/sdk/cmdline-tools/latest/bin:$PATH"
export PATH="/Users/daiduong/fvm/default/bin:$PATH"
export PATH="/Users/daiduong/go/bin:$PATH"

## [Completion]
## Completion scripts setup. Remove the following line to uninstall
[[ -f /Users/daiduong/.dart-cli-completion/zsh-config.zsh ]] && . /Users/daiduong/.dart-cli-completion/zsh-config.zsh || true
## [/Completion]

export PATH="/Users/daiduong/.shorebird/bin:$PATH"
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
bindkey '       ' autosuggest-accept

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# bun completions
[ -s "/Users/daiduong/.bun/_bun" ] && source "/Users/daiduong/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

export PATH="$PATH:$HOME/.pub-cache/bin"

# Added by Amplify CLI binary installer
export PATH="$HOME/.amplify/bin:$PATH"
alias fman="compgen -c | fzf | xargs man"

. "$HOME/.cargo/env"
export PATH="$PATH:/Volumes/MacOS - Home/source/bin/chromedriver-mac-arm64"

eval "$(hugo completion zsh)"
