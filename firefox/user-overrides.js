user_pref("browser.startup.page", 3); // 0102

user_pref("browser.sessionstore.privacy_level", 0); // 1003
user_pref("toolkit.winRegisterApplicationRestart", true); // 1005
user_pref("browser.shell.shortcutFavicons", true); // 1006

user_pref("privacy.userContext.ui.enabled", false); // 1701

user_pref("pdfjs.disabled", true); // 2620
user_pref("browser.download.useDownloadDir", true); // 2651
user_pref("browser.download.alwaysOpenPanel", true); // 2652
user_pref("extensions.webextensions.restrictedDomains", ""); // 2662
user_pref("privacy.clearOnShutdown.history", false); // 2811
user_pref("privacy.cpd.history", false); // 2820

user_pref("privacy.resistFingerprinting", false); // 4501
user_pref("privacy.resistFingerprinting.block_mozAddonManager", false); // 4503
user_pref("privacy.resistFingerprinting.letterboxing", false); // 4504
user_pref("webgl.disabled", false); // 4520 [mostly pointless if not verwenden RFP]

user_pref("media.eme.enabled", false); // 5508
//user_pref("browser.urlbar.maxRichResults", 0); // 5011
user_pref("privacy.resistFingerprinting.pbmode", true); // 4501
user_pref("extensions.formautofill.addresses.enabled", false); // 5017
user_pref("extensions.formautofill.creditCards.enabled", false); // 5017

//aelius
user_pref("browser.urlbar.maxRichResults", 0);
user_pref("browser.urlbar.clickSelectsAll", true);
user_pref("privacy.globalprivacycontrol.enabled", true);
user_pref("browser.urlbar.clickSelectsAll", true);
user_pref("signon.firefoxRelay.feature", "disabled");
user_pref("browser.taskbar.previews.enable", false);
user_pref("browser.ctrlTab.sortByRecentlyUsed", true);
user_pref("browser.display.use_document_fonts", 0); //override web page fonts
user_pref("browser.download.start_downloads_in_tmp_dir", true); //for play-with m3u spam
user_pref("browser.sessionstore.persist_closed_tabs_between_sessions", true); //tab-stash restore tabs w/ history
user_pref("browser.tabs.closeWindowWithLastTab", false);
user_pref("browser.tabs.inTitlebar", 1);
user_pref("browser.taskbar.previews.enable", false);
user_pref("config.trim_on_minimize", true); //Windows trim memory when fx minimized
user_pref("devtools.editor.keymap", "vim"); //binds for source editor
user_pref("extensions.pocket.enabled", false);
user_pref("font.name.sans-serif.x-western", "Sylfaen"); //serif font for sans serif
//user_pref("font.name.serif.x-western", "Sitka Display");
user_pref("font.name.serif.x-unicode", "GohuFont 14 Nerd Font");
user_pref("font.name.serif.x-western", "GohuFont 14 Nerd Font");
user_pref("font.size.variable.x-western", 14);
user_pref("font.size.variable.x-unicode", 14);
user_pref("intl.regional_prefs.use_os_locales", true);
user_pref("network.http.windows-sso.enabled", true);
user_pref("reader.color_scheme", "sepia");
user_pref("reader.content_width", 5);
user_pref("reader.font_size", 3);
user_pref("reader.font_type", "serif");
user_pref("reader.line_height", 2);
user_pref("reader.parse-on-load.force-enabled", true); //readability always available
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true); //load userChrome.css

///  NATURAL SMOOTH SCROLLING V4 "SHARP" - AveYo, 2020-2022             preset     [default]
user_pref("general.smoothScroll.msdPhysics.continuousMotionMaxDeltaMS",   12);//NSS    [120]
user_pref("general.smoothScroll.msdPhysics.enabled",                    true);//NSS  [false]
user_pref("general.smoothScroll.msdPhysics.motionBeginSpringConstant",   200);//NSS   [1250]
user_pref("general.smoothScroll.msdPhysics.regularSpringConstant",       250);//NSS   [1000]
user_pref("general.smoothScroll.msdPhysics.slowdownMinDeltaMS",           25);//NSS     [12]
user_pref("general.smoothScroll.msdPhysics.slowdownMinDeltaRatio",     "2.0");//NSS    [1.3]
user_pref("general.smoothScroll.msdPhysics.slowdownSpringConstant",      250);//NSS   [2000]
user_pref("general.smoothScroll.currentVelocityWeighting",             "1.0");//NSS ["0.25"]
user_pref("general.smoothScroll.stopDecelerationWeighting",            "1.0");//NSS  ["0.4"]

/// adjust multiply factor for mousewheel - or set to false if scrolling is way too fast  
user_pref("mousewheel.system_scroll_override.horizontal.factor",         200);//NSS    [200]
user_pref("mousewheel.system_scroll_override.vertical.factor",           200);//NSS    [200]
user_pref("mousewheel.system_scroll_override_on_root_content.enabled",  true);//NSS   [true]
user_pref("mousewheel.system_scroll_override.enabled",                  true);//NSS   [true]

/// adjust pixels at a time count for mousewheel - cant do more than a page at once if <100
user_pref("mousewheel.default.delta_multiplier_x",                       100);//NSS    [100]
user_pref("mousewheel.default.delta_multiplier_y",                       100);//NSS    [100]
user_pref("mousewheel.default.delta_multiplier_z",                       100);//NSS    [100]

///  this preset will reset couple extra variables for consistency
user_pref("apz.allow_zooming",                                          true);//NSS   [true]
user_pref("apz.force_disable_desktop_zooming_scrollbars",              false);//NSS  [false]
user_pref("apz.paint_skipping.enabled",                                 true);//NSS   [true]
user_pref("apz.windows.use_direct_manipulation",                        true);//NSS   [true]
user_pref("dom.event.wheel-deltaMode-lines.always-disabled",           false);//NSS  [false]
user_pref("general.smoothScroll.durationToIntervalRatio",                200);//NSS    [200]
user_pref("general.smoothScroll.lines.durationMaxMS",                    150);//NSS    [150]
user_pref("general.smoothScroll.lines.durationMinMS",                    150);//NSS    [150]
user_pref("general.smoothScroll.other.durationMaxMS",                    150);//NSS    [150]
user_pref("general.smoothScroll.other.durationMinMS",                    150);//NSS    [150]
user_pref("general.smoothScroll.pages.durationMaxMS",                    150);//NSS    [150]
user_pref("general.smoothScroll.pages.durationMinMS",                    150);//NSS    [150]
user_pref("general.smoothScroll.pixels.durationMaxMS",                   150);//NSS    [150]
user_pref("general.smoothScroll.pixels.durationMinMS",                   150);//NSS    [150]
user_pref("general.smoothScroll.scrollbars.durationMaxMS",               150);//NSS    [150]
user_pref("general.smoothScroll.scrollbars.durationMinMS",               150);//NSS    [150]
user_pref("general.smoothScroll.mouseWheel.durationMaxMS",               200);//NSS    [200]
user_pref("general.smoothScroll.mouseWheel.durationMinMS",                50);//NSS     [50]
user_pref("layers.async-pan-zoom.enabled",                              true);//NSS   [true]
user_pref("layout.css.scroll-behavior.spring-constant",                "250");//NSS    [250]
user_pref("mousewheel.transaction.timeout",                             1500);//NSS   [1500]
user_pref("mousewheel.acceleration.factor",                               10);//NSS     [10]
user_pref("mousewheel.acceleration.start",                                -1);//NSS     [-1]
user_pref("mousewheel.min_line_scroll_amount",                             5);//NSS      [5]
user_pref("toolkit.scrollbox.horizontalScrollDistance",                    5);//NSS      [5]
user_pref("toolkit.scrollbox.verticalScrollDistance",                      3);//NSS      [3]
/// source: https://github.com/AveYo/fox/blob/main/Natural%20Smooth%20Scrolling%20for%20user.js
