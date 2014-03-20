hints.addMode(
    'e',
    'Tineye Image Search',
	function (elem) {
		liberator.open('http://www.tineye.com/search/?pluginver=firefox-1.0&url=' + encodeURIComponent(elem.src), liberator.NEW_TAB);
	},
	function () { return "//*[@src]"; }
);