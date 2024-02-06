local launch_menu = {}

table.insert(launch_menu, {
  label = 'PowerShell',
  args = { 'powershell.exe', '-NoLogo' },
})
table.insert(launch_menu, {
  label = 'Pwsh',
  args = { 'pwsh.exe', '-NoLogo' },
})
table.insert(launch_menu, {
  label = 'ucrt64',
  args = { 'msys2_shell.cmd', '-full-path', '-defterm', '-no-start', '-here', '-ucrt64', '-shell', 'dash', '-l' },
})
table.insert(launch_menu, {
  label = 'msys',
  args = { 'msys2_shell.cmd', '-full-path', '-defterm', '-no-start', '-here', '-msys2', '-shell', 'dash', '-l' },
})
table.insert(launch_menu, {
  label = 'cmd',
  args = { 'cmd' },
})
table.insert(launch_menu, {
  label = 'btm',
  args = { 'btm' },
})

return launch_menu
