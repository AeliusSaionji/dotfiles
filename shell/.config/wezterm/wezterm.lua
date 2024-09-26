local wezterm = require 'wezterm'
local mux = wezterm.mux
local act = wezterm.action
local binds = require 'keybinds'
local launch_progs = require 'launch_table'
local domains = require 'domains'
local config = {}
if wezterm.config_builder then
  config = wezterm.config_builder()
end
config.keys = binds.keybinds
config.mouse_bindings = binds.mouse_bindings
config.launch_menu = launch_progs
config.ssh_domains = domains.ssh_domains

-- Visuals backend
config.front_end = "WebGpu"
config.max_fps = 120
config.animation_fps = 120
config.visual_bell = {
  fade_in_duration_ms = 750,
  fade_out_duration_ms = 75,
  target = "CursorColor" }
-- config.colors = {
--   visual_bell = '#FFFFFF',
-- }

config.window_background_gradient = {
  colors = { '#0f0c29', '#302b63', '#24243e' },
  orientation = { Radial = { cx = 0.75, cy = 0.75, radius = 1.25 } } }

config.enable_kitty_keyboard = true

config.font = wezterm.font 'VictorMono Nerd Font'
-- config.harfbuzz_features = { 'calt', 'clig', 'liga' }
config.harfbuzz_features = { 'calt', 'clig', 'liga', 'ss01', 'ss02', 'ss03', 'ss04', 'ss05', 'ss06', 'ss07', 'ss08' }

config.font_size = 11
config.line_height = 1.2
config.adjust_window_size_when_changing_font_size = false
-- config.use_fancy_tab_bar = true
config.enable_tab_bar = false
config.switch_to_last_active_tab_when_closing_tab = true
config.enable_scroll_bar = true
config.scrollback_lines = 5000
config.ssh_backend = "Ssh2"
config.default_prog = { 'pwsh.exe', '-NoLogo' }

return config
