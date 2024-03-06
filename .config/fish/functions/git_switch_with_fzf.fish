function git_switch_with_fzf
  set dummy "  New branch!!"
  set branch (begin; echo $dummy; git branch --all; end | fzf)

  if test -n "$branch"
    if test "$branch" = "$dummy"
      echo "Enter the new branch name:"
      read -l new_branch
      if git branch --all | grep -q $new_branch
        echo "Branch $new_branch already exists"
        git switch $new_branch
      else
        git switch -c $new_branch
      end
    else
      git switch (echo $branch | sed 's/.* //')
    end
  else 
    echo "No branch selected"
  end
  commandline -f repaint
end
