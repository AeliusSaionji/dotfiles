local wezterm = require 'wezterm'
local binds = {}

binds.keybinds =
{
  {
    key = '}',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.SplitPane
    {
      direction = 'Right',
      command = { args = { 'broot' } },
      size = { Percent = 25 },
    },
  },
  {
    key = '{',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.SplitPane
    {
      direction = 'Left',
      command = { args = { 'broot' } },
      size = { Percent = 25 },
    },
  },
  {
    key = 'D',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.DetachDomain 'CurrentPaneDomain',
  },
  {
    key = '?',
    mods = 'CTRL',
    action = wezterm.action.DisableDefaultAssignment,
  },
}

binds.mouse_bindings = {
  {
    event = { Down = { streak = 3, button = 'Left' } },
    mods = 'NONE',
    action = wezterm.action.SelectTextAtMouseCursor 'SemanticZone',
  },
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'CTRL',
    action = wezterm.action.OpenLinkAtMouseCursor,
  },
  {
    event = { Down = { streak = 1, button = { WheelUp = 1 } } },
    mods = 'CTRL',
    action = wezterm.action.IncreaseFontSize,
  },
  {
    event = { Down = { streak = 1, button = { WheelDown = 1 } } },
    mods = 'CTRL',
    action = wezterm.action.DecreaseFontSize,
  },
}

return binds
