local wezterm = require 'wezterm'
local mux = wezterm.mux
local act = wezterm.action
local config = {}
if wezterm.config_builder then
  config = wezterm.config_builder()
end


config.visual_bell = {
  fade_in_function = {CubicBezier={0.0, 0.0, 0.58, 1.0}},
  fade_in_duration_ms = 150,
  fade_out_function = 'Linear',
  fade_out_duration_ms = 1500,

}
config.colors = {
  visual_bell = '#FF2020',
}

config.font = wezterm.font('Hack Nerd Font')
config.font_size = 12
config.line_height = 1.2
config.adjust_window_size_when_changing_font_size = false
config.color_scheme = 'Laserwave (Gogh)'
config.use_fancy_tab_bar = true
config.max_fps = 120
config.front_end = "WebGpu"
config.webgpu_power_preference = "HighPerformance"
config.prefer_egl = false
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
-- config.win32_system_backdrop = 'Acrylic'
-- config.default_prog = { 'pwsh.exe', '-NoLogo' }
config.default_prog = { 'broot' }

local launch_menu = require("launch_table")
config.launch_menu = launch_menu
local binds = require("keybinds")
config.keys = binds.keybinds
config.mouse_bindings = binds.mouse_bindings

return config
