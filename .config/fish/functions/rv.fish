function rv
  set pr (gh pr list | fzf | awk '{print $1}')

  if test -z "$pr"
    return
  end

  gh pr checkout $pr

  set title (gh pr view $pr --json title --jq '.title' | string collect)
  set description (gh pr view $pr --json body --jq '.body' | string collect)

  set diff (gh pr diff $pr | string collect)

  if test -z "$diff"
    return
  end

  set prompt "ソフトウェアエンジニアとして、このリポジトリに来た次の差分のPRをレビューしてください\n\n必要があればこのリポジトリの内容を走査せよ。\nレビューのスコープは変更差分に閉じなさい。\n\nTitle:\n$title\n\nDescription:\n$description\n\nDiff:\n$diff"

  set tool (test -n "$RV_AI_TOOL" && echo $RV_AI_TOOL || echo "claude")

  switch $tool
    case codex
      codex "$prompt"
    case '*'
      claude "$prompt"
  end
end
