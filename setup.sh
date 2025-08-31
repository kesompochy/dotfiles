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

# Install fisher if not installed
if not functions -q fisher
  echo "Installing fisher..."
  curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher
  echo "Fisher installed!"
end

# Install nvm.fish and Node.js
if not functions -q nvm
  echo "Installing nvm.fish..."
  fisher install jorgebucaran/nvm.fish
  echo "nvm.fish installed!"
end

# Install Node.js LTS if not installed
if not command -v node > /dev/null; or not nvm list | grep -q "lts"
  echo "Installing Node.js LTS..."
  nvm install lts
  nvm use lts
  echo "Node.js LTS installed!"
else
  echo "Node.js already installed"
end

# Install vim-plug
if not test -f ~/.local/share/nvim/site/autoload/plug.vim
  echo "Installing vim-plug..."
  curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  echo "vim-plug install complete!"
else
  echo "vim-plug already installed!"
end

echo "Installing neovim plugins..."
nvim +PlugInstall +qall

echo "Installing coc extensions..."
nvim -c "CocInstall" -c "q" 

echo "Neovim setup complete!"

# Install Claude Code
if not command -v claude > /dev/null
  echo "Installing Claude Code..."
  curl -fsSL https://claude.ai/install.sh | bash
  echo "Claude Code installed!"
else
  echo "Claude Code already installed"
end

# Install zenhan.exe for WSL IME control
if test -n "$WSL_DISTRO_NAME"
  if not test -f ~/.local/bin/zenhan.exe
    echo "Installing zenhan.exe for IME control..."
    mkdir -p ~/.local/bin
    curl -L https://github.com/kyoh86/zenhan/releases/download/v0.0.1/zenhan.exe -o ~/.local/bin/zenhan.exe
    chmod +x ~/.local/bin/zenhan.exe
    echo "zenhan.exe installed!"
  else
    echo "zenhan.exe already installed"
  end
end

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

# Link tmux.conf
if test -e $HOME/.tmux.conf
  if not test -L $HOME/.tmux.conf
    mv $HOME/.tmux.conf $HOME/.tmux.conf_backup_(date +%Y%m%d_%H%M%S)
    ln -s (pwd)/.tmux.conf $HOME/.tmux.conf
    echo "Linked .tmux.conf (backup created)"
  else
    echo ".tmux.conf symlink already exists"
  end
else
  ln -s (pwd)/.tmux.conf $HOME/.tmux.conf
  echo "Linked .tmux.conf"
end

# Link gitconfig
if test -e $HOME/.gitconfig
  if not test -L $HOME/.gitconfig
    mv $HOME/.gitconfig $HOME/.gitconfig_backup_(date +%Y%m%d_%H%M%S)
    ln -s (pwd)/.gitconfig $HOME/.gitconfig
    echo "Linked .gitconfig (backup created)"
  else
    echo ".gitconfig symlink already exists"
  end
else
  ln -s (pwd)/.gitconfig $HOME/.gitconfig
  echo "Linked .gitconfig"
end

echo "===Finished linking config files!==="

echo "===Start sourcing config files...==="
echo "Sourcing fish config"
source $home_config_dir/fish/config.fish
echo "Sourcing tmux config"
tmux source ~/.tmux.conf
echo "===Finished sourcing config files!==="

# Setup Hyper configuration for Windows (if in WSL)
function setup_hyper_config
  set -l windows_user $argv[1]
  
  # Default to current Windows user if not provided
  if test -z "$windows_user"
    set windows_user (cmd.exe /c echo %USERNAME% 2>/dev/null | tr -d '\r')
  end
  
  # Check if Hyper is installed on Windows
  set hyper_config_dir "/mnt/c/Users/$windows_user/AppData/Roaming/Hyper"
  if not test -d $hyper_config_dir
    echo "Hyper not found for user $windows_user, skipping"
    return 0
  end
  
  echo "===Setting up Hyper configuration for Windows user: $windows_user==="
  
  set hyper_config_path "$hyper_config_dir/.hyper.js"
  set dotfiles_hyper_path (pwd)/windows/hyper/.hyper.js
  
  # Check if dotfiles hyper config exists
  if not test -f $dotfiles_hyper_path
    echo "No Hyper config found in dotfiles, skipping"
    return 0
  end
  
  # Create symlink using Windows mklink command
  set windows_path "C:\\Users\\$windows_user\\AppData\\Roaming\\Hyper\\.hyper.js"
  set wsl_path "\\\\wsl.localhost\\Ubuntu\\home\\kesompochy\\ghq\\github.com\\kesompochy\\dotfiles\\windows\\hyper\\.hyper.js"
  set current_dir (pwd)
  cd /mnt/c
  set mklink_result (cmd.exe /c "mklink $windows_path $wsl_path" 2>&1)
  set mklink_status $status
  cd $current_dir
  
  if test $mklink_status -eq 0
    echo "Created Windows symlink for Hyper config"
  else
    # mklink failed - show reason but continue
    echo "Skipping Hyper symlink: $mklink_result"
  end
  
  return 0
end

# Run Hyper setup if in WSL
if test -n "$WSL_DISTRO_NAME"
  setup_hyper_config
end
