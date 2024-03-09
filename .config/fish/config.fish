# view

## TODO

# path

set -x GOPATH $HOME/go
set -x PATH $PATH $GOPATH/bin /opt/homebrew/bin

set -x BUN_INSTALL $HOME/.bun
set -x PATH $BUN_INSTALL/bin:$PATH

set -x WIN_CHROME_PATH /mnt/c/'Program Files'/Google/Chrome/Application/chrome.exe

# wsl2の時刻同期コマンド
if grep -q microsoft /proc/version
  if test -d "/run/WSL"
    echo "WSL2 detected, setting up time sync..."
    sudo hwclock --hctosys
  end
end
