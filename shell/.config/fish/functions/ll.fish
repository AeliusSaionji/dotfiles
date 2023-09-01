function ll --wraps=ls --wraps='lsd -l' --description 'alias ll lsd -l'
  if command -v lsd
    lsd -l $argv
    return
  end
  ls -l
end
