abbr -a -- gs 'git status'
abbr -a -- Dr 'sudo systemctl daemon-reload'
abbr -a -- dr 'systemctl --user daemon-reload'
abbr -a -- j 'journalctl --user'
abbr -a -- J journalctl
abbr -a -- s 'systemctl --user'
abbr -a -- S systemctl
abbr -a -- Sf 'systemctl --failed -o json | yq .[].unit'
abbr -a -- sf 'systemctl --user --failed -o json | yq .[].unit'
abbr -a -- lla 'eza --long --icons always --all'
abbr -a -- la 'eza --icons always --all'
abbr -a -- l 'eza --icons always'
abbr -a -- ll 'eza --long --icons always'
abbr -a -- pu 'podman unshare'
