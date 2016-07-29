const {classes: Cc, interfaces: Ci, utils: Cu} = Components
let {Preferences} = Cu.import('resource://gre/modules/Preferences.jsm', {})

Preferences.set({
	'browser.newtabpage.enabled': false,
	'browser.startup.page': 3, //Show my windows and tabs from last time
	'browser.tabs.closeWindowWithLastTab': false,
	'browser.urlbar.suggest.searches': true, //Show search suggestions in location bar
	'datareporting.healthreport.uploadEnabled': false,
//	'pdfjs.disabled': true,
	'privacy.donottrackheader.enabled': true,
	'signon.rememberSignons': false, //Disable internal password manager

	/* VimFX Keybinds */
	'extensions.VimFx.mode.normal.scroll_half_page_down': "<c-d>",
	'extensions.VimFx.mode.normal.scroll_half_page_up': "<c-u>",
	'extensions.VimFx.mode.normal.tab_close': "d",
	'extensions.VimFx.mode.normal.tab_close_other': "",
	'extensions.VimFx.mode.normal.tab_close_to_end': "",
	'extensions.VimFx.mode.normal.tab_restore': "u",
	'extensions.VimFx.mode.normal.tab_restore_list': "U",
	'extensions.VimFx.mode.normal.tab_select_most_recent': "gl    <c-6>",
	'extensions.VimFx.mode.normal.tab_select_next': "J    gt",
	'extensions.VimFx.mode.normal.tab_select_previous': "K    gT",
})

