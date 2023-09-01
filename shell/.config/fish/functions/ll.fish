function ll --wraps=ls --wraps='lsd -l' --description 'alias ll lsd -l'
  if command -q lsd
    command lsd --config-file ~/.config/lsd/config.yaml -l $argv
    return
  end
  ls -l
end
