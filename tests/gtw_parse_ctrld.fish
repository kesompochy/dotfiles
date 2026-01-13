#!/usr/bin/env fish
source (dirname (status --current-filename))/../.config/fish/functions/__gtw_parse.fish

function assert_eq --argument-names actual expected label
  if test "$actual" != "$expected"
    printf 'FAIL %s: got \"%s\" expected \"%s\"\n' "$label" "$actual" "$expected"
    exit 1
  end
end

set -l raw (printf '\nctrl-d\n/path\tlabel\tbranch\n' | string collect)
set -l expected (printf '/path\tlabel\tbranch')
set -l parsed (__gtw_parse "$raw")
assert_eq "$parsed[1]" "ctrl-d" "expected key ctrl-d"
assert_eq "$parsed[2]" "" "expected query empty"
assert_eq "$parsed[3]" "$expected" "expected selection path"

echo ok
