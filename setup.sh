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
set repo_config_dir (pwd)/.config
set home_config_dir $HOME/.config

for dir in (ls $repo_config_dir)
  set repo_subdir $repo_config_dir/$dir
  set home_subdir $home_config_dir/$dir
  echo "Linking $repo_subdir to $home_subdir!!"

  if test -e $home_subdir
    set backup_dir $home_subdir"_backup_"(date +%Y%m%d_%H%M%S)
    mv $home_subdir $backup_dir
    echo "Backed up existing configs to $backup_dir!!"
  end
  ln -s $repo_subdir $home_subdir
  echo "Linked $repo_subdir to $home_subdir!!"
end
echo "===Finished linking config files!==="
