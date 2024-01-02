function ghq_fzf
  set dir (ghq list -p | fzf)
  if test -n "$dir"
    cd $dir
    commandline -f repaint
  end
end

