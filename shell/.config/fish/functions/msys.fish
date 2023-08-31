function msys --wraps=exec\ bash\ -c\ \'source\ shell\ msys\ \&\&\ exec\ fish\ -l\' --description alias\ msys\ exec\ bash\ -c\ \'source\ shell\ msys\ \&\&\ exec\ fish\ -l\'
  exec bash -c 'source shell msys && exec fish -l' $argv
        
end
