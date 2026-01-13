#!/usr/bin/env fish
# Basic parser tests for gtw fzf output (NUL-separated)

set -l dir (dirname (status --current-filename))
source "$dir/../.config/fish/functions/__gtw_parse.fish"

function assert_eq --argument-names actual expected label
  if test "$actual" != "$expected"
    printf 'FAIL %s: got "%s" expected "%s"\n' "$label" "$actual" "$expected"
    exit 1
  end
end

# Enterで既存選択（キーなし、クエリ空、選択あり）
set -l raw_move (printf '\n\n/Users/kesompo/ghq/github.com/kesompochy/dotfiles\t.\tagents-md\t0\n' | string collect)
set -l move (__gtw_parse "$raw_move")
assert_eq "$move[1]" "" "move key"
assert_eq "$move[2]" "" "move query"
assert_eq "$move[3]" "/Users/kesompo/ghq/github.com/kesompochy/dotfiles	.	agents-md	0" "move selection"

# ctrl-dで削除（キー=ctrl-d、クエリ空、選択あり）
set -l raw_delete (printf 'ctrl-d\n\n/Users/kesompo/ghq/github.com/kesompochy/dotfiles/hoge\thoge\thoge\t0\n' | string collect)
set -l del (__gtw_parse "$raw_delete")
assert_eq "$del[1]" "ctrl-d" "delete key"
assert_eq "$del[2]" "" "delete query"
assert_eq "$del[3]" "/Users/kesompo/ghq/github.com/kesompochy/dotfiles/hoge	hoge	hoge	0" "delete selection"

# キーなし・クエリ空・既存選択（新規扱いにならない）
set -l raw_existing (printf '\n\n/Users/kesompo/ghq/github.com/kesompochy/dotfiles\t.\tagents-md\t0\n' | string collect)
set -l ex (__gtw_parse "$raw_existing")
assert_eq "$ex[1]" "" "existing key"
assert_eq "$ex[2]" "" "existing query"
assert_eq "$ex[3]" "/Users/kesompo/ghq/github.com/kesompochy/dotfiles	.	agents-md	0" "existing selection"

# 一致なしで新規作成（キーなし、クエリあり、選択なし）
set -l raw_new (printf 'new-branch\n\n' | string collect)
set -l nw (__gtw_parse "$raw_new")
assert_eq "$nw[1]" "" "new key"
assert_eq "$nw[2]" "new-branch" "new query"
assert_eq "$nw[3]" "" "new selection"

echo ok
