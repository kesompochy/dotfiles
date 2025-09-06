# view

## TODO

# path

set -x GOPATH $HOME/go
fish_add_path $GOPATH/bin
fish_add_path /opt/homebrew/bin

fish_add_path /usr/local/bin
fish_add_path $HOME/.bun/bin
fish_add_path $BUN_INSTALL/bin

set -x WIN_CHROME_PATH /mnt/c/'Program Files'/Google/Chrome/Application/chrome.exe

# eval (nodenv init - | source)

fish_add_path $HOME/.rbenv/bin
status --is-interactive; and source (rbenv init -|psub)
fish_add_path $HOME/.rbenv/shims

fish_add_path $HOME/.pyenv/bin
status is-interactive; and pyenv init --path | source
pyenv init - | source

fish_add_path /opt/homebrew/share/google-cloud-sdk/bin

set -x LDFLAGS "-L/opt/homebrew/opt/capstone/lib"
set -x CPPFLAGS "-I/opt/homebrew/opt/capstone/include"

# abbr

abbr --add gssh /Users/kesompo/ghq/github.com/kesompochy/gcloud-ssh/gcloud-ssh
abbr --add k kubectl

# krew
set -q KREW_ROOT; and set -gx PATH $PATH $KREW_ROOT/.krew/bin; or set -gx PATH $PATH $HOME/.krew/bin

# flags
set -g __k8s_prompt_enabled 0

set -x USE_GKE_GCLOUD_AUTH_PLUGIN True

# asdf
source (brew --prefix asdf)/libexec/asdf.fish
