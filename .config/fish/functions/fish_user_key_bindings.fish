function fish_user_key_bindings
  for mode in default insert
    bind -M $mode \cg ghq_fzf
    bind -M $mode \cs git_switch_with_fzf
    bind -M $mode \cx kubectx_fzf
    bind -M $mode \cn kubens_fzf
    bind -M $mode \cv focus-vscode-fzf
    bind -M $mode \cw gtw
  end
end
