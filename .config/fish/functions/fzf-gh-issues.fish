function fzf-gh-issues
  set issue (gh issue list | fzf | awk '{print $1}')

  if test -n "$issue"
    gh issue view $issue
  end
end
