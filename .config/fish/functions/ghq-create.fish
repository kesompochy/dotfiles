function ghq-create --argument repo_name 
  gh repo create $repo_name --public
  ghq get "git@github.com:"(git config user.name)"/"$repo_name".git"
  cd (ghq root)"/github.com/"(git config user.name)"/"$repo_name
end
