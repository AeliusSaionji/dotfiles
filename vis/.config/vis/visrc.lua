-- load standard vis runtime files, must be done before anything else
require('vis')

local plug = require('plugins/vis-plug')

-- configure plugins in an array of tables with git urls and options
local plugins = {
  { 'erf/vis-highlight', alias = 'hi' },
  { 'erf/vis-sneak' },
  { 'lutobler/vis-commentary' },
  { 'jpaulogg/vis-ins-completion.git' },
  { 'thimc/vis-colorizer' },
  { 'samlwood/vis-gruvbox', theme = true, file = 'gruvbox' },
  -- { url = 'https://repo.or.cz/vis-parkour.git', alias = 'parkour' },
  { url = 'https://repo.or.cz/vis-motsel.git' },
  { url = 'https://repo.or.cz/vis-toggler.git', alias = 'toggler' },
  { url = 'https://repo.or.cz/vis-surround.git' },
  { url = 'https://repo.or.cz/vis-exchange.git' },
  { url = 'https://repo.or.cz/vis-pairs.git', alias = 'pairs' },
  -- { url = 'https://gitlab.com/muhq/vis-spellcheck' },

  -- configure themes by setting 'theme = true'. The theme 'file' will be set on INIT
  -- { 'samlwood/vis-gruvbox', theme = true, file = 'gruvbox' },
}

-- require and optionally install plugins on init
plug.init(plugins, true)

-- access plugins via alias
plug.plugins.hi.patterns[' +\n'] = { style = 'back:#444444' }
-- plug.plugins.hi.patterns['\t+'] = { style = 'back:yellow' }
plug.plugins.toggler.config = require('plugins/vis-toggler.example')
plug.plugins.pairs.autopairs = false
-- plug.plugins.parkour.autoselect = true

vis:command_register('br', function(argv)
  local cmd = string.format('wezterm cli split-pane --left --percent 25 -- env SHELL=/bin/bash broot')
  os.execute(cmd)
end, "Open broot in new wez pane")

vis:command_register('tsp', function(argv)
  local file = vis.win.file
  local path = argv[1] or file.path
  local cmd = string.format('wezterm cli split-pane --left -- env SHELL=/bin/bash vis "%s" &', path)
  os.execute(cmd)
end, "Open file in a new wez pane")

vis:command_register('xsp', function(argv)
  local file = vis.win.file
  local path = argv[1] or file.path
  local cmd = string.format('wezterm cli spawn --new-window -- env SHELL=/bin/bash vis "%s" &', path)
  os.execute(cmd)
end, "Open file in a new wez window")

vis:command('set autoindent')
vis:command('change-256colors')
vis:command('set colorcolumn 80')
vis:command('set cursorline')
vis:command('set escdelay 50')
vis:command('set expandtab')
vis:command('set relativenumbers')
vis:command('set shell "/bin/sh"')
vis:command('set show-tabs')
vis:command('set tabwidth 2')
