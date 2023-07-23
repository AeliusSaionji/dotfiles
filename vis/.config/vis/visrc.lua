-- load standard vis runtime files, must be done before anything else
require('vis')

local plug = require('plugins/vis-plug')

-- configure plugins in an array of tables with git urls and options
local plugins = {
	{ 'erf/vis-highlight', alias = 'hi' },
	{ 'erf/vis-sneak' },
	{ 'lutobler/vis-commentary' },
	{ url = 'https://repo.or.cz/vis-toggler.git', alias = 'toggler' },
	{ url = 'https://repo.or.cz/vis-surround.git' },
	{ url = 'https://repo.or.cz/vis-exchange.git' },
	-- { url = 'https://gitlab.com/muhq/vis-spellcheck' },

	-- configure themes by setting 'theme = true'. The theme 'file' will be set on INIT
	-- { 'samlwood/vis-gruvbox', theme = true, file = 'gruvbox' },
}

-- require and optionally install plugins on init
plug.init(plugins, true)

-- access plugins via alias
plug.plugins.hi.patterns[' +\n'] = { style = 'back:#444444' }
plug.plugins.hi.patterns['\t+'] = { style = 'back:yellow' }
plug.plugins.toggler.config = require('plugins/vis-toggler.example')