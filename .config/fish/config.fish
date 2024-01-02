function ghq_peco 
  set dir (ghq list -p | peco)
  if test -n "$dir"
    cd $dir
    commandline -f repaint
  end
end

bind \cg ghq_peco

set -x GOPATH $HOME/go
set -x PATH $PATH $GOPATH/bin
