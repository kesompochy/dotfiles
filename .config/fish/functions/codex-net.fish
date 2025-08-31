function codex-net --wraps codex --description 'Codex with network access enabled in workspace-write sandbox'
  command codex --config 'sandbox_workspace_write.network_access=true' $argv
end

