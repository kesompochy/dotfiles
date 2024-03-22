# view

## TODO

# path

set -x GOPATH $HOME/go
set -x PATH $PATH $GOPATH/bin /opt/homebrew/bin

set -x BUN_INSTALL $HOME/.bun
set -x PATH $BUN_INSTALL/bin:$PATH

set -x WIN_CHROME_PATH /mnt/c/'Program Files'/Google/Chrome/Application/chrome.exe

set -x PATH $HOME/.nodenv/bin $PATH
status --is-interactive; and source (nodenv init -|psub)
