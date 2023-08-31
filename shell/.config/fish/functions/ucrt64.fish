function ucrt64 --wraps=exec\ bash\ -c\ \'source\ shell\ ucrt64\ \&\&\ exec\ fish\ -l\' --description alias\ ucrt64\ exec\ bash\ -c\ \'source\ shell\ ucrt64\ \&\&\ exec\ fish\ -l\'
  exec bash -c 'source shell ucrt64 && exec fish -l' $argv
        
end
