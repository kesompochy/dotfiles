function ghq_peco
  set dir (ghq list -p | peco)
  if test -n "$dir"
    cd $dir
    commandline -f repaint
  end
end
