function git_switch_with_fzf
  set branch (git branch --all | fzf)

  if test -n "$branch"
    git switch (echo $branch | sed 's/.* //')
  else 
    echo "No branch selected"
  end
  commandline -f repaint
end
