local wezterm = require 'wezterm'
local binds = require 'keybinds'
local launch_progs = require 'launch_table'
local domains = require 'domains'
local config = {}
if wezterm.config_builder then
  config = wezterm.config_builder()
end
config.keys = binds.keys
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

config.initial_cols = 160
config.window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
}
-- config.window_background_gradient = {
--   colors = { '#0f0c29', '#302b63', '#24243e' },
--   orientation = { Radial = { cx = 0.75, cy = 0.75, radius = 1.25 } } }
-- config.window_background_image = 'c:/Users/aelius/pic.jpg'
-- config.window_background_opacity = 0.95
config.inactive_pane_hsb = {
  saturation = 0.7,
  brightness = 0.5,
}


config.enable_kitty_keyboard = true

config.font = wezterm.font {
  family = 'Victor Mono',
  harfbuzz_features = { 'calt', 'clig', 'liga', 'ss01', 'ss02', 'ss06', 'ss07', 'ss08' }
}
config.font_size = 8

-- Workaround for possible bug where fallback nerd glyphs shrink, but built in
-- glyphs from patched fonts don't. Not needed if using an external nerd font.
config.allow_square_glyphs_to_overflow_width = 'Always'

config.adjust_window_size_when_changing_font_size = true
-- config.use_fancy_tab_bar = true
config.warn_about_missing_glyphs = false
config.enable_tab_bar = false
config.switch_to_last_active_tab_when_closing_tab = true
config.enable_scroll_bar = true
config.scrollback_lines = 5000
config.ssh_backend = "Ssh2"
config.default_gui_startup_args = { 'connect', 'unix' }
config.default_prog = { 'pwsh.exe', '-NoLogo' }

return config
