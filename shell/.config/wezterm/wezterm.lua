local wezterm = require 'wezterm'
local mux = wezterm.mux
local act = wezterm.action
local config = {}
if wezterm.config_builder then
  config = wezterm.config_builder()
end


config.visual_bell = {
  fade_in_function = 'Linear',
  fade_in_duration_ms = 250,
}
config.colors = {
  visual_bell = '#FFFFFF',
}

-- config.font = wezterm.font 'Fira code'
-- config.font = wezterm.font 'GohuFont 14 Nerd Font'
config.font = wezterm.font 'VictorMono Nerd Font'
config.font_size = 14
config.line_height = 1.0
-- config.allow_square_glyphs_to_overflow_width = "Never"
config.harfbuzz_features = { 'calt=1', 'clig=1', 'liga=1' }
config.adjust_window_size_when_changing_font_size = false
config.color_scheme = 'Laserwave (Gogh)'
config.use_fancy_tab_bar = true
config.max_fps = 120
config.front_end = "WebGpu"
config.webgpu_power_preference = "HighPerformance"
config.prefer_egl = false
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
-- config.win32_system_backdrop = 'Acrylic'
config.default_prog = { 'pwsh.exe', '-NoLogo' }

local launch_menu = require("launch_table")
config.launch_menu = launch_menu
local binds = require("keybinds")
config.keys = binds.keybinds
config.mouse_bindings = binds.mouse_bindings

return config
