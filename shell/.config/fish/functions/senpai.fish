function senpai --wraps=senpai-irc --description 'alias senpai=senpai-irc'
  if command -q senpai-irc
    senpai-irc $argv;
    return
  end
  command senpai $argv;
end
