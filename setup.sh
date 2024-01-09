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
if test -e $HOME/.config/nvim
  set backup_dir "$HOME/.config/nvim_backup_"(date +%Y%m%d)
  mv $HOME/.config/nvim $backup_dir
  echo "Backed up existing configs, $backup_dir"
end
ln -s (pwd)/.config/nvim $HOME/.config/nvim
if test -e $HOME/.config/fish
  set backup_dir "$HOME/.config/fish_backup_"(date +%Y%m%d)
  mv $HOME/.config/fish $backup_dir
  echo "Backed up existing configs, $backup_dir"
end
ln -s (pwd)/.config/fish $HOME/.config/fish
echo "===Finished linking config files!==="
