# view

## TODO

# path
set -e fish_user_paths

set -x GOPATH $HOME/go
fish_add_path $GOPATH/bin
fish_add_path /opt/homebrew/bin

set -x BUN_INSTALL $HOME/.bun
fish_add_path $BUN_INSTALL/bin

set -x WIN_CHROME_PATH /mnt/c/'Program Files'/Google/Chrome/Application/chrome.exe

fish_add_path $HOME/.nodenv/bin
nodenv init - | source

fish_add_path $HOME/.tfenv/bin

fish_add_path /usr/lib/llvm16/bin

# pyenv setup
set -x PYENV_ROOT $HOME/.pyenv
fish_add_path $PYENV_ROOT/bin
pyenv init - | source

# vim like keybind
fish_vi_key_bindings

# updates PATH for the Google Cloud SDK.
if [ -f '/home/kesompochy/google-cloud-sdk/path.fish.inc' ]; . '/home/kesompochy/google-cloud-sdk/path.fish.inc'; end
