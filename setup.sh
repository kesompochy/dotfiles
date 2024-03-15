#!/usr/bin/env fish
echo "===Start installing packages...==="

echo "Install packages for "(uname)"!!"
switch (uname)
  case Linux
    sudo apt update
    # sudo apt install neovim # This is not the latest version
    sudo apt install -y fzf
    sudo apt install -y fish
    sudo apt install -y golang-go
    go install github.com/x-motemen/ghq@latest

  case Darwin
    brew install neovim
    brew install fzf
end

echo "Change default shell to fish!!"
sudo chsh -s (which fish) $USER

echo "Install common packages!!"
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

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
ln -s (pwd)/.tmux.conf $HOME/.tmux.conf

echo "===Finished linking config files!==="

echo "===Start sourcing config files...==="
echo "Sourcing fish config"
source $home_config_dir/fish/config.fish
echo "Sourcing tmux config"
tmux source ~/.tmux.conf
echo "===Finished sourcing config files!==="
