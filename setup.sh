#!/usr/bin/env fish
echo "===Start installing packages...==="

echo "Install packages for "(uname)"!!"
switch (uname)
  case Linux
    sudo apt-get install neovim
    sudo apt-get install fzf

  case Darwin
    brew install neovim
    brew install fzf
end

echo "Install common packages!!"
go install github.com/x-motemen/ghq@latest

echo "===Finished installing packages!==="

echo "===Start linking config files...==="
echo "===Finished linking config files!==="
