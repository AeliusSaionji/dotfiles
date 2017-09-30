# Base settings
c.auto_save.session = True
c.completion.quick = True
c.content.default_encoding = "utf-8"
c.downloads.position = "bottom"
c.downloads.remove_finished = 5000
c.scrolling.smooth = True
c.tabs.last_close = "blank"
c.tabs.position = "right"
c.tabs.select_on_remove = "last-used"
c.tabs.show = "never"
c.url.default_page = "about:blank"
c.url.searchengines = {'DEFAULT': 'https://www.bing.com/search?q={}'}
c.url.searchengines['a'] = 'https://smile.amazon.com/s/url=search-alias%3Daps&field-keywords={}'
c.url.searchengines['aur'] = 'https://aur.archlinux.org/packages/?O=0&K={}'
c.url.searchengines['aw'] = 'https://wiki.archlinux.org/index.php?search={}'
c.url.searchengines['g'] = 'https://www.google.com/search?q={}'
c.url.searchengines['w'] = 'https://en.wikipedia.org/w/index.php?search={}'
c.url.start_pages = ["about:blank"]

# Bindings
config.bind('<F3>', 'spawn --detach mpv {url}', mode='normal')
config.bind('O', 'set-cmd-text :open {url:pretty}', mode='normal', force=True)
config.bind('t', 'set-cmd-text -s :open -t', mode='normal', force=True)
config.bind('T', 'set-cmd-text :open -t {url:pretty}', mode='normal', force=True)
config.bind('b', 'set-cmd-text -s :buffer', mode='normal', force=True)
config.bind(';o', 'hint all current', mode='normal', force=True)
config.bind(';t', 'hint all tab-fg', mode='normal', force=True)
config.unbind('D', mode='normal')
