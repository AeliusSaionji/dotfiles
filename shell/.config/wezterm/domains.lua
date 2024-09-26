local wezterm = require 'wezterm'
local ssh_domains = {}

for host, config in pairs(wezterm.enumerate_ssh_hosts()) do
  table.insert(ssh_domains, {
    -- the name can be anything you want; we're just using the hostname
    name = host,
    -- remote_address must be set to `host` for the ssh config to apply to it
    remote_address = host,
    assume_shell = 'Posix',
    multiplexing = "WezTerm",
    local_echo_threshold_ms = 10,
  })
end

return {

  ssh_domains = ssh_domains,
  unix_domains = { { name = 'unix' } },
  wsl_domains = {},

}
