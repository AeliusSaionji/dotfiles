return {

  ssh_domains =
  {
    {
      name = 'reServer',
      remote_address = 'reServer.flamingsteel.net',
      username = 'aelius',
      assume_shell = 'Posix',
      multiplexing = 'WezTerm',
      local_echo_threshold_ms = 10,
    },
    {
      name = 'Pyrrha',
      remote_address = 'Pyrrha.flamingsteel.net',
      username = 'aelius',
      assume_shell = 'Posix',
      multiplexing = 'WezTerm',
      local_echo_threshold_ms = 10,
    },
  },
  unix_domains = { { name = 'unix' } },
  wsl_domains = {},

}
