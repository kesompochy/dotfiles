function gtw
  if not type -q git
    echo 'git が見つかりません'
    return 1
  end

  if not type -q fzf
    echo 'fzf が見つかりません'
    return 1
  end

  set -l root (git rev-parse --show-toplevel 2>/dev/null)
  or begin
    echo 'git 管理下で実行してください'
    return 1
  end

  while true
    set -l entries (git worktree list --porcelain | python3 -c 'import os, sys
root = os.path.abspath(sys.argv[1])
cwd = os.path.realpath(sys.argv[2])
entries = []
record = {}
for raw in sys.stdin:
    line = raw.strip()
    if not line:
        if "worktree" in record:
            entries.append(record)
        record = {}
        continue
    key, value = raw.split(" ", 1)
    record[key] = value.strip()
if record.get("worktree"):
    entries.append(record)
for item in entries:
    path = item["worktree"]
    branch = item.get("branch", "")
    head = item.get("HEAD", "")
    rel = os.path.relpath(path, root)
    is_current = "1" if os.path.realpath(path) == cwd else "0"
    if branch.startswith("refs/heads/"):
        branch = branch[len("refs/heads/"):]
    elif branch.startswith("refs/"):
        branch = branch[len("refs/"):]
    if not branch:
        branch = head[:7] if head else ""
    print(f"{path}\t{rel}\t{branch}\t{is_current}")
' "$root" "$PWD")

    if test (count $entries) -eq 0
      echo 'worktree が見つかりません'
      return 1
    end

    set -l lines
    set -l paths
    for entry in $entries
      set -l parts (string split \t -- $entry)
      set -l path $parts[1]
      set -l rel $parts[2]
      set -l branch $parts[3]
      set -l is_current $parts[4]

      if test -z "$rel"
        set rel "."
      end

      set -l label $rel
      if test "$is_current" = "1"
        set label "* $rel"
      end

      set -l branch_display $branch
      if test -z "$branch_display"
        set branch_display '-'
      end

      set lines $lines (string join \t $path $label $branch_display)
      set paths $paths $path
    end

    set -l header 'Enter:移動  Ctrl-D:削除  一致なし:新規作成'
    set -l fzf_result (printf '%s\n' $lines | FZF_DEFAULT_OPTS='' fzf --print-query --expect=ctrl-d --delimiter='\t' --with-nth=2,3 --nth=2,3 --header="$header" --layout=reverse --height=60% --select-1 --exit-0)
    set -l fzf_status $status

    set -l lines_out (string split \n -- $fzf_result)
    while test (count $lines_out) -gt 0 -a -z "$lines_out[-1]"
      set lines_out $lines_out[1..-2]
    end

    set -l key ''
    set -l query ''
    set -l selection ''

    set -l rest $lines_out

    if test (count $rest) -ge 2 -a "$rest[2]" = "ctrl-d"
      set key "ctrl-d"
      set query (string trim -- $rest[1])
      set rest $rest[3..-1]
    else
      if test (count $rest) -ge 1 -a "$rest[1]" = "ctrl-d"
        set key "ctrl-d"
        set rest $rest[2..-1]
      end

      if test (count $rest) -ge 1
        set query (string trim -- $rest[1])
        set rest $rest[2..-1]
      end
    end

    for ln in $rest
      if test -n "$ln"
        set selection $ln
        break
      end
    end

    if test $fzf_status -ne 0
      if test -n "$query"
        set selection ''
      else
        if status --is-interactive
          commandline -f repaint
        end
        return $fzf_status
      end
    end

    if test "$key" = "ctrl-d"
      if test -z "$selection"
        echo '削除する worktree が選択されていません'
        continue
      end
    end

    if test -z (string trim -- $selection)
      set -l new_name (string trim -- $query)
      if test -z "$new_name"
        continue
      end

      set -l branch_name $new_name
      set branch_name (string trim -- $branch_name)

      set -l worktree_path (python3 -c 'import os, sys
root = os.path.abspath(sys.argv[1])
name = sys.argv[2].strip()
expanded = os.path.expanduser(name)
if os.path.isabs(expanded):
    path = os.path.abspath(expanded)
else:
    repo_name = os.path.basename(root.rstrip(os.sep)) or os.path.basename(os.path.realpath(root))
    relative = expanded
    has_sep = os.path.sep in relative or (os.path.altsep and os.path.altsep in relative)
    if not has_sep and relative not in ("", ".", ".."):
        relative = os.path.join(relative, repo_name)
    path = os.path.abspath(os.path.join(root, relative))
print(path)
' "$root" "$branch_name")

      set -l normalized_paths
      for p in $paths
        set normalized_paths $normalized_paths (python3 -c 'import os, sys; print(os.path.realpath(sys.argv[1]))' "$p")
      end

      set -l normalized_target (python3 -c 'import os, sys; print(os.path.realpath(sys.argv[1]))' "$worktree_path")

      if contains -- "$normalized_target" $normalized_paths
        echo '既存の worktree と同じパスです'
        continue
      end

      if test -e "$worktree_path"
        if not test -d "$worktree_path"
          echo "指定パスはディレクトリではありません: $worktree_path"
          continue
        end
        if test (count (command ls -A "$worktree_path" 2>/dev/null)) -ne 0
          echo "ディレクトリが空ではありません: $worktree_path"
          continue
        end
      end

      mkdir -p (dirname "$worktree_path")

      set -l add_status 1
      if git show-ref --verify --quiet "refs/heads/$branch_name"
        git worktree add "$worktree_path" "$branch_name"
        set -l add_status $status
      else
        git worktree add -b "$branch_name" "$worktree_path" HEAD
        set -l add_status $status
      end

      if test $add_status -ne 0
        if test -f "$worktree_path/.git" -o -d "$worktree_path/.git"
          git -C "$worktree_path" rev-parse --quiet HEAD >/dev/null 2>&1
          if test $status -eq 0
            set add_status 0
          end
        end
      end

      if test $add_status -eq 0
        builtin cd "$worktree_path"
        if status --is-interactive
          commandline -f repaint
        end
        return 0
      end

      echo 'worktree の作成に失敗しました'
      read -l -P 'Enter を押して続行...' gtw_pause
      continue
    end

    set -l selected_parts (string split \t -- $selection)
    set -l selected_path $selected_parts[1]

    if test "$key" = "ctrl-d"
      set -l root_real (python3 -c 'import os, sys; print(os.path.realpath(sys.argv[1]))' "$root")
      set -l selected_real (python3 -c 'import os, sys; print(os.path.realpath(sys.argv[1]))' "$selected_path")
      if test "$selected_real" = "$root_real"
        echo 'メイン worktree は削除できません'
        continue
      end

      set -l current_real (python3 -c 'import os, sys; print(os.path.realpath(sys.argv[1]))' "$PWD")
      if test "$selected_real" = "$current_real"
        builtin cd "$root"
      end

      git worktree remove "$selected_path" 2>/dev/null
      set -l remove_status $status

      if test $remove_status -ne 0
        set -l changes (git -C "$selected_path" status --porcelain 2>/dev/null)
        if test (count $changes) -gt 0
          echo '未コミット変更があるため --force で削除します'
          git worktree remove --force "$selected_path"
          set remove_status $status
        end
      end

      if test $remove_status -ne 0
        echo '削除に失敗しました'
        read -l -P 'Enter を押して続行...' gtw_pause_delete
      end
      continue
    end

    builtin cd "$selected_path"
    if status --is-interactive
      commandline -f repaint
    end
    return 0
  end
end
