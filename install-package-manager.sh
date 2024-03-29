#!/usr/bin/env bash

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
