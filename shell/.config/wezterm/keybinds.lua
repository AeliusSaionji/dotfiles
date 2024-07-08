local binds = {}
local wezterm = require 'wezterm'
local act = wezterm.action

binds.keys = {
  { key = 'D', mods = 'CTRL|SHIFT', action = act.DetachDomain 'CurrentPaneDomain', },
  { key = '_', mods = 'CTRL|SHIFT', action = act.SplitPane { direction = 'Down', size = { Percent = 50 }, } },
  { key = '|', mods = 'CTRL|SHIFT', action = act.SplitPane { direction = 'Right', size = { Percent = 50 }, } },
  { key = 'Enter', mods = 'ALT', action = act.DisableDefaultAssignment },
}

binds.mouse_bindings = {
  { event = { Down = { streak = 3, button = 'Left' } }, mods = 'NONE', action = act.SelectTextAtMouseCursor 'SemanticZone', },
  { event = { Up = { streak = 1, button = 'Left' } }, mods = 'CTRL', action = act.OpenLinkAtMouseCursor, },
  { event = { Down = { streak = 1, button = { WheelUp = 1 } } }, mods = 'CTRL', action = act.IncreaseFontSize, },
  { event = { Down = { streak = 1, button = { WheelDown = 1 } } }, mods = 'CTRL', action = act.DecreaseFontSize, },
}

return binds
