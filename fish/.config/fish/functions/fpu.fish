function fpu --wraps='flatpak --user update; and flatpak --user uninstall --unused' --wraps='flatpak update --user; and flatpak uninstall --user --unused' --description 'alias fpu flatpak update --user; and flatpak uninstall --user --unused'
  flatpak update --user; and flatpak uninstall --user --unused $argv; 
end
