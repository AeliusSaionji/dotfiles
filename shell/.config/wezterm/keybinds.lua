local wezterm = require("wezterm")
local binds = {}

binds.keybinds = {
  {
    key = '}',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.SplitPane {
      direction = 'Right',
      command = { args = { 'broot' } },
      size = { Percent = 25},
    },
  },
  {
    key = '{',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.SplitPane {
      direction = 'Left',
      command = { args = { 'broot' } },
      size = { Percent = 25},
    },
  },
}

binds.mouse_bindings = {
  {
    event = { Down = { streak = 3, button = 'Left' } },
    action = wezterm.action.SelectTextAtMouseCursor 'SemanticZone',
    mods = 'NONE',
  },
}

return binds
