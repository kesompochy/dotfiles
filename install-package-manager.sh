#!/usr/bin/env bash

# Install nvm and Node.js
if [ ! -d "$HOME/.nvm" ]; then
  echo "Installing nvm..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  echo "nvm installed!"
else
  echo "nvm already installed"
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
fi

# Install Node.js LTS if not installed
if ! nvm ls --no-colors | grep -q "lts"; then
  echo "Installing Node.js LTS..."
  nvm install --lts
  nvm use --lts
  nvm alias default lts/*
  echo "Node.js LTS installed!"
else
  echo "Node.js LTS already installed"
fi

if [ ! -f ~/.local/share/nvim/site/autoload/plug.vim ]; then
  echo "Installing vim-plug..."
  curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  echo "vim-plug install complete!"
else
  echo "vim-plug already installed!"
fi

echo "Installing neovim plugins..."

nvim +PlugInstall +qall

echo "Installing coc extensions..."

nvim -c "CocInstall" -c "q" 

echo "Neovim setup complete!"
