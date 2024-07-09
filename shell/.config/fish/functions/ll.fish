function ll --wraps=ls --wraps='eza -l' --description 'alias ll eza -l'
  if command -q eza
    command eza --classify auto --icons --hyperlink --long --git $argv
    return
  end
  ls -l --hyperlink=auto
end
