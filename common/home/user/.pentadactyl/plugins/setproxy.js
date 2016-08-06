
/* *******************************************************************************
 *
 * This is a Pentadactyl plugin; for more on Pentadactyl, see here:
 * http://dactyl.sourceforge.net/pentadactyl/
 *
 * This plugin implements commands for changing the effective Firefox proxy
 * settings:
 *    :add-proxy {URI} [exclusions]
 *    :set-proxy {index}
 *    :set-proxy direct
 *    :show-proxies
 *    :show-proxy
 *    :remove-proxy {index}
 *
 * See the documentation for more information:
 *    :h setproxy-plugin
 *
 * Installation:
 *    place this file in "~/.pentadactyl/plugins/"; that's all.
 * 
 * Copyright:
 *    Stephen Blott (smblott@gmail.com)
 * 
 * License:
 *    MIT License
 *    http://opensource.org/licenses/mit-license.php
 *
 * Additional copyright:
 *    see the additional copyright and license notices regarding parseUri()
 *    from Steven Levithan, below.
 */

/* *******************************************************************************
 *
 * Version 0.12:
 *    - Released: 2011/04/24
 *    - added "direct", "auto" and "system" arguments for :set-proxy
 *    - added a "-quiet" argument for :set-proxy
 *    - improved documentation
 *    - refactored code
 *    - improved the semantics of the main operations for some corner cases
 *    - removed a limitation on PAC file names (in an obscure corner case)
 *    - improved code efficiency in some places (although that is unlikely to
 *      make any practical difference)
 *
 * Version 0.11:
 *    - Released: 2011/04/22
 *    - shoot! no sooner submitted than I find a dumb bug
 *    - the test for whether a newly-added proxy is already on the list of
 *      proxies was saying it was when it wasn't; so the "newly-added proxy" was
 *      never added; fixed now
 *
 * Version 0.10:
 *    - Released: 2011/04/22
 *    - This plugin implements commands for configuring Firefox's proxy settings.
 *      The two main commands are :add-proxy and :set-proxy.  Normally,
 *      :add-proxy is used to append proxies to the list of available proxies
 *      (typically from the pentadactylrc file) before :set-proxy is used to
 *      activate one of them.
 *
 */

/* *******************************************************************************
 * some preliminaries ...
 */

"use strict";

// XML.ignoreWhitespace = false;
// XML.prettyPrinting   = false;

/* *******************************************************************************
 * some code borrowed from elsewhere ...
    *
    */

    // parseUri 1.2.2
    // (c) Steven Levithan <stevenlevithan.com>
    // MIT License

    function parseUri (str) {
            var     o   = parseUri.options,
                    m   = o.parser[o.strictMode ? "strict" : "loose"].exec(str),
                    uri = {},
                    i   = 14;

            while (i--) uri[o.key[i]] = m[i] || "";

            uri[o.q.name] = {};
            uri[o.key[12]].replace(o.q.parser, function ($0, $1, $2) {
                    if ($1) uri[o.q.name][$1] = $2;
            });

            return uri;
    };

    parseUri.options = {
            strictMode: false,
            key: ["source","protocol","authority","userInfo","user","password","host","port","relative","path","directory","file","query","anchor"],
            q:   {
                    name:   "queryKey",
                    parser: /(?:^|&)([^&=]*)=?([^&]*)/g
            },
            parser: {
                    strict: /^(?:([^:\/?#]+):)?(?:\/\/((?:(([^:@]*)(?::([^:@]*))?)?@)?([^:\/?#]*)(?::(\d*))?))?((((?:[^?#\/]*\/)*)([^?#]*))(?:\?([^#]*))?(?:#(.*))?)/,
                    loose:  /^(?:(?![^:@]+:[^:@\/]*@)([^:\/?#.]+):)?(?:\/\/)?((?:(([^:@]*)(?::([^:@]*))?)?@)?([^:\/?#]*)(?::(\d*))?)(((\/(?:[^?#](?![^?#\/]*\.[^?#\/.]+(?:[?#]|$)))*\/?)?([^?#\/]*))(?:\?([^#]*))?(?:#(.*))?)/
            }
    };

   /*
    *
 * ... end of code borrowed from elsewhere
 * *******************************************************************************/

/* *******************************************************************************
 * utilities ...
 */

var identity =
    function (x) x;

var might_be_an_index =
    function (index) /^[0-9]*$/.test(index);

var is_index =
    function (index) might_be_an_index(index) && index.length;

var swap =
    function(l,i,j)
    {
        assert(i < l.length, "swap: index i out of range");
        assert(j < l.length, "swap: index j out of range");
        var t = l[i]; l[i] = l[j]; l[j] = t;
    };

var simple_completer =
    function (prefix, string)
        ( prefix.length && string.indexOf(prefix) == 0 )
            ? string
            : prefix;

var pad = // is there really no sprintf() workalike in Javascript?
    function (str, len)
    {
        assert(str.length <= len, "pad: str too long");
        return str.toString()
                  + Array(len - str.toString().length + 1).join(" ");
    }

var assert_exception = 
    function (message) { this.message = message; };

assert_exception.prototype.toString
    = function () 'Failed assertion: ' + this.message;

var assert =
    function (value, message)
    {
        if ( ! value )
        {
            dactyl.log("setproxy exception: " + message);
            throw new assert_exception(message);
        }
    };

/* *******************************************************************************
 * proxy types ...
 */

var DIRECT                 = 0,
    MANUAL                 = 1,
    PAC                    = 2,
    //                    no 3,
    AUTOMATIC              = 4,
    SYSTEM                 = 5,

    nonuri_proxies         = [ "direct", "auto", "system" ],
    known_proxies          = [],
    proxy_descs            = [];

    proxy_descs[DIRECT]    = "direct connection",
    proxy_descs[MANUAL]    = "manual proxy configuration",
    proxy_descs[PAC]       = "proxy auto-configuration [PAC]",
    proxy_descs[AUTOMATIC] = "auto-detect proxy settings",
    proxy_descs[SYSTEM]    = "use system proxy settings";

var proxy_desc             = function (type) proxy_descs[type]
                                               ? "type=" + type + " (" + proxy_descs[type] + ")"
                                               : "<ERROR>"; // should not happen at all

var proxy_type_uri         = function(type) type == MANUAL || type == PAC,
    proxy_type_nonuri      = function(type) type == DIRECT || type == AUTOMATIC || type == SYSTEM,
    proxy_type_valid       = function(type) proxy_type_uri(type) || proxy_type_nonuri(type),
    proxy_type_invalid     = function(type) type == undefined // short-circuit the common case
                                            || ! proxy_type_valid(type);

/* proxy_type():
 *
 * we can only handle URIs which include their protocol type here, because
 * parseUri() seems unreliable if the protocol type is omitted
 *
 * if a URI has a HOST and a PORT but no PATH, then it is taken to be a manual
 * proxy (also, surely it doesn't make sense to have an HTTP proxy for which
 * its own protocol type isn't HTTP?)
 *
 * if a URI's PATH ends with ".pac", then it is taken to be a PAC file
 */

var proxy_type =
    function (obj)
    {
        assert(obj, "proxy_type: no obj");
        assert(obj.length != 0, "proxy_type: empty obj");

        if ( obj.length == 1 && proxy_type_invalid(obj.proxy_type) )
        {
            switch ( obj[0] )
            {
            case "direct": obj.proxy_type = DIRECT;    break;
            case "auto"  : obj.proxy_type = AUTOMATIC; break;
            case "system": obj.proxy_type = SYSTEM;    break;
            }
            if ( proxy_type_nonuri(obj.proxy_type) )
            {
                obj.proxy_text    = proxy_descs[obj.proxy_type];
                obj.proxy_builtin = true;
            }
        }

        if ( proxy_type_invalid(obj.proxy_type) )
        {
            obj.uri = parseUri(obj[0]);
            if ( obj.uri.protocol )
            {
                if ( obj.uri.protocol == "http"
                        && obj.uri.host
                        && obj.uri.port
                        && ( obj.uri.path == "/" || ! obj.uri.path )
                   )
                {
                    obj.proxy_type   = MANUAL;
                    obj.proxy_host   = obj.uri.host;
                    obj.proxy_port   = parseInt(obj.uri.port);
                    obj.proxy_except = obj.slice(1).join(" ");
                    obj[0]           = obj[0].replace(/\/+$/, "");
                }
                if ( /\.pac$/.test(obj.uri.path) || obj.force_pac )
                    obj.proxy_type = PAC;
                if ( proxy_type_uri(obj.proxy_type) )
                {
                    obj.proxy_text = obj.join(" ");
                    obj.proxy_desc = proxy_desc(obj.proxy_type);
                }
            }
        }

        return obj.proxy_type;
    };

/* *******************************************************************************
 * the list of known/available proxies ...
 */

var compare_proxies =
    function (a,b)
        (a.silently_added ? 1 : 0) - (b.silently_added ? 1 : 0);

var current_proxy =
    function ()
    {
        var proxy;
        switch ( prefs.get('network.proxy.type') )
        {
        case MANUAL:
            proxy = [  "http://"
                     +  prefs.get('network.proxy.http')
                     + ":"
                     +  prefs.get('network.proxy.http_port')
                     ] .concat( prefs.get('network.proxy.no_proxies_on')
                              .split(/[, ]+/)
                              .filter( identity ) );
            break;
        case PAC:
            proxy = [ prefs.get('network.proxy.autoconfig_url') ];
            proxy.force_pac = true;
            break;
        case DIRECT:
            proxy = [ "direct" ];
            break;
        case AUTOMATIC:
            proxy = [ "auto" ];
            break;
        case SYSTEM:
            proxy = [ "system" ];
            break;
        default:
            // this really should not happen
            assert(false, "current_proxy: failed to determine current proxy settings");
            return undefined;
        }
        proxy.silently_added = true;
        proxy_type(proxy); // for side effect
        return proxy;
    };

var add_proxy =
    function (args)
    {
        if ( args == undefined || args.length == 0 )
            args = current_proxy();

        assert(args, "add_proxy: no args");
        assert(args.length, "add_proxy: args empty");

        if ( proxy_type_invalid(proxy_type(args)) ) // note side effect
            return dactyl.echoerr("add-proxy: invalid argument: [" + args[0] + "]");

        if ( proxy_type_nonuri(proxy_type(args)) )
        {
            assert(args.silently_added, "add_proxy: non silently added uri");
            return; // silently added, so silently skipped here
        }

        if ( proxy_type(args) == PAC && args.length != 1 )
            return dactyl.echoerr("add-proxy: too many arguments for automatic proxy configuration");

        /* don't re-add a proxy which is already on the list
         *
         * however, if this proxy is already on the list but was previously
         * "silently added", then remove it; it will be re-added (but in a
         * more suitable position) below
         */

        for (var i in known_proxies)
            if ( args.proxy_text == known_proxies[i].proxy_text )
            {
                if ( args.silently_added || ! known_proxies[i].silently_added )
                    return;
                known_proxies.splice(i,1);
                break;
            }

        for (var i in known_proxies)
            assert(args.proxy_text != known_proxies[i].proxy_text, "add_proxy: this should not be here");

        known_proxies.push(args);
        known_proxies.sort(compare_proxies);
            // Array.sort() is apparently stable for Gecko >= 1.9; it seems
            // indeed to be so
    };

var available_proxies =
    function (include_nonuri_proxy_types, options)
    {
        var proxies = [];

        for (var i in known_proxies)
            proxies.push( { index: i,
                            desc:  known_proxies[i].proxy_text,
                            proxy: known_proxies[i] } );

        for (var i in proxies)
            if ( proxies[i].proxy.silently_added )
                proxies[i].desc += "; silently added (from a previously-active proxy setting)";

        if ( include_nonuri_proxy_types )
            proxies.splice( 0, 0, { index: "direct", desc: proxy_descs[DIRECT]    },
                                  { index: "auto",   desc: proxy_descs[AUTOMATIC] },
                                  { index: "system", desc: proxy_descs[SYSTEM]    } );

        if ( options )
            for (var i in options)
                proxies.splice(0, 0, { index: options[i][0], desc: options[i][1] });

        return proxies;
    };

var remove_proxy =
    function (args)
    {
        assert(args.length == 1, "remove_proxy: too many/few arguments");
        var index = args[0], removed;

        if ( ! is_index(index) )
            return dactyl.echoerr("remove-proxy: invalid argument [" + index + "]");

        if ( known_proxies.length <= index )
            return dactyl.echoerr("remove-proxy: invalid index [" + args[0] + "]");

        removed = known_proxies.splice(index, 1)[0];
        dactyl.echo("remove-proxy: " + removed.proxy_text + "; " + removed.proxy_desc);
    };

/* *******************************************************************************
 * the main operations ...
 */

var real_set_proxy =
    function (args, quiet)
    {
        assert(proxy_type_valid(proxy_type(args)), "real_set_proxy: invalid proxy type");
        add_proxy(); // remember the current proxy settings, if necessary

        switch ( proxy_type(args) )
        {
        case MANUAL:
            add_proxy(args); // add the new setting to list
            prefs.set('network.proxy.type',                 MANUAL);
            prefs.set('network.proxy.http',                 args.proxy_host);
            prefs.set('network.proxy.http_port',            args.proxy_port);
            prefs.set('network.proxy.no_proxies_on',        args.proxy_except);
            prefs.set('network.proxy.share_proxy_settings', true);
            break;
        case PAC:
            add_proxy(args); // add the new setting to list
            prefs.set('network.proxy.type',           PAC);
            prefs.set('network.proxy.autoconfig_url', args[0]);
            break;
        case DIRECT:
        case AUTOMATIC:
        case SYSTEM:
            prefs.set('network.proxy.type', proxy_type(args));
            break;
        default:
            // this should not happen
            assert(false, "real_set_proxy: invalid proxy type");
            break;
        };
        if ( ! quiet )
            show_proxy();
    };

var set_proxy =
    function (args)
    {
        var quiet = false;
        var first = simple_completer(args[0], "-quiet");

        if ( first == "-quiet" )
        {
            quiet = true;
            args.shift();
        }

        if ( args.length == 1 && is_index(args[0]) )
        {
            if ( known_proxies.length <= args[0] )
                return dactyl.echoerr("set-proxy: invalid index [" + args[0] + "]");

            real_set_proxy(known_proxies[args[0]], quiet);
            return;
        }

        if ( args.length == 1 )
            for (var i in nonuri_proxies)
                args[0] = simple_completer(args[0], nonuri_proxies[i]);

        if ( proxy_type_invalid(proxy_type(args)) ) // note side effect
            return dactyl.echoerr("set-proxy: invalid argument [" + args[0] + "]");

        real_set_proxy(args, quiet);
    };

var format_len   = nonuri_proxies[0] /* "direct" */ .length + 1 /* the space */ + 2 /* extra spaces */;
var show_proxies =
        function (args)
            dactyl.echo( [ "Available proxies:" ]
                            .concat( available_proxies(true)
                                     .map( function (p) "  " +  pad(p.index, format_len) + p.desc )
                                     .sort() ).join("\n") );

var show_proxy =
        function (args)
        {
            var obj  = current_proxy();
            var type = proxy_type(obj);

            assert(proxy_type_valid(type), "show-proxy: could not determine current proxy setting");
            return dactyl.echo("proxy: " + obj.proxy_text);
        };

/* *******************************************************************************
 * completion ...
 */

var null_completer =
    function (context,message)
    {
        context.message     = message;
        context.title       = undefined;
        context.keys        = undefined;
        context.completions = undefined;
        return context;
    };

var on_first_argument =
    function (context, argument)
    {
        // this is hideous; I really need to learn how to do completion
        // properly
        var strs = context.value.substr(0,context.offset).split(/\s+/);
        if ( argument )
        {
            for (var i=1; i<strs.length-1; i+=1)
                if ( simple_completer(strs[i], argument) != argument )
                    return false;
            return true;
        }
        return strs.length == 2;
    };

var set_proxy_compare =
    function (a,b)
    {
        a = a.text;
        b = b.text;
        if      ( /^[0-9]/.test(a) ) a = 1;
        else if ( /^[a-z]/.test(a) ) a = 2;
        else if ( /^-/    .test(a) ) a = 3;
        if      ( /^[0-9]/.test(b) ) b = 1;
        else if ( /^[a-z]/.test(b) ) b = 2;
        else if ( /^-/    .test(b) ) b = 3;
        return a - b;
    };

var set_proxy_completer =
    function (context)
    {
        if ( on_first_argument(context, "-quiet") )
        {
            context.message     = "[:set-proxy] available proxies (or 'direct', 'auto' or 'system'):";
            context.title       = [ "SELECTION (choice or {MANUAL-URI} [EXCLUSIONS...] or {PAC-URI})",
                                    "DETAILS" ];
            context.keys        = { text: "index", description: "desc" };
            context.completions = available_proxies(true, [ [ "-quiet", "operate silently (any non-empty prefix will do)" ] ]);
            context.compare     = set_proxy_compare;
            return context;
        }

        return null_completer(context, "[:set-proxy] arguments: {MANUAL-URI} [EXCLUSIONS...] or {PAC-URI}");
    };

var add_proxy_completer =
    function (context)
        null_completer(context, "[:add-proxy] arguments: {MANUAL-URI} [EXCLUSIONS...] or {PAC-URI}");

var remove_proxy_completer =
    function (context)
    {
        if ( on_first_argument(context) )
        {
            context.message     = "[:remove-proxy] available proxies:";
            context.title       = [ "SELECTION INDEX",
                                    "DETAILS" ];
            context.keys        = { text: "index", description: "desc" };
            context.completions = available_proxies();
            return context;
        }

        return null_completer(context, "[:remove-proxy] arguments: {INDEX}");
    };

/* *******************************************************************************
 * pentadactyl commands ...
 */

group.commands.add( [ "add-proxy", "ap" ],
                      "Add a new proxy to the list of available proxies.",
                       add_proxy,
                    {  argCount: "*",
                       completer: add_proxy_completer },
                       true );

group.commands.add( [ "set-proxy", "sp" ],
                      "Set the active proxy.",
                       set_proxy,
                    {  argCount: "+",
                       completer: set_proxy_completer },
                       true );

group.commands.add( [ "remove-proxy", "rp" ],
                      "Remove a proxy from the list of available proxies.",
                       remove_proxy,
                    {  argCount: "1",
                       completer: remove_proxy_completer },
                       true );

group.commands.add( [ "show-proxies", "spxs" ],
                      "Show the all available proxies.",
                       show_proxies,
                    {  argCount: "0" },
                       true );

group.commands.add( [ "show-proxy", "spx" ],
                      "Show the the currently-active proxy.",
                       show_proxy,
                    {  argCount: "0" },
                       true );

/* *******************************************************************************
 * END OF MAIN IMPLEMENTATION
 *
 * documentation ...
 */
/*
var INFO =
    <plugin name="setproxy" version="0.12"
            href="http://code.google.com/p/dactyl/issues/detail?id=513"
            summary="Configure Firefox's proxy settings"
            xmlns={NS}>
        <author email="smblott@gmail.com">Stephen Blott</author>
        <license href="http://opensource.org/licenses/mit-license.php">MIT</license>
        <project name="Pentadactyl" min-version="1.0"/>

        <p>
            This plugin implements commands for configuring Firefox's proxy
            settings.  The two main commands are <ex>:add-proxy</ex> and
            <ex>:set-proxy</ex>.  Typically, <ex>:add-proxy</ex> is used to
            append proxies to a list of available proxies before
            <ex>:set-proxy</ex> is then used to activate one of them.
        </p>

        <item>
            <tags>:ap :add-proxy</tags>
            <spec>:add-proxy</spec>
            <spec>:add-proxy <a>manual-URI</a> <oa>exclusions</oa></spec>
            <spec>:add-proxy <a>PAC-URI</a></spec>
            <description>
                <p>
                    Append a new proxy to the list of available proxies.  With no
                    arguments, the currently-active proxy (if
                            any) is appended to the list of available proxies
                    (if it is not already on the list).
                </p>
                <p>
                    If the first argument is a URI, then that URI must include
                    the protocol specification ("<tt>http://</tt>", "<tt>file://</tt>",
                    etc).  The URI represents a
                    manually-configured proxy if its HOST and PORT are
                    specified but its PATH is empty.  It represents
                    a PAC file if its PATH ends in the text "<tt>.pac</tt>".
                    Otherwise, the URI is considered invalid and
                    <ex>:add-proxy</ex> fails.
                </p>
                <p>
                    If the URI represents a
                    manually-configured proxy, then any subsequent
                    arguments are taken to be exclusions (just as the Firefox
                    dialog box allows excluded domains to be specified) for
                    which direct connections are made.
                    If the URI represents a PAC file, then that URI
                    must be the only argument.
                </p>

                <p>
                    The <ex>:add-proxy</ex> command is typically used in the
                    <t>pentadactylrc</t> file.  Because this is a plugin, any
                    <ex>:add-proxy</ex> calls in the <t>pentadactylrc</t> file
                    <em>must follow</em> a suitable call of
                    <ex>:loadplugins</ex>.
                </p>

                <example><ex>:add-proxy http://localhost:40440/</ex></example>

                <example><ex>:add-proxy http://wwwproxy.computing.dcu.ie:8000/</ex></example>

                <example><ex>:add-proxy http://wwwproxy.computing.dcu.ie:8000/ localhost dcu.ie</ex></example>
                <p>
                    Add a proxy, but it will not be used for <str>localhost</str>
                    or <str>dcu.ie</str> (or any sub-domain thereof).
                </p>

                <example><ex>:add-proxy http://www.computing.dcu.ie/proxy.pac</ex></example>

                <example><ex>:add-proxy file:///usr/home/blott/.proxy.pac</ex></example>

                <example><ex>:loadplugins "setproxy.js"</ex></example>
                <p>
                    In the <t>pentadactylrc</t> file, ensure that the <t>setproxy-plugin</t>
                    is loaded before the <ex>:add-proxy</ex> command is used.
                </p>

                <note>
                    However, the following <em>will not work</em>. The first two do not
                    include the required protocol specification and the third
                    does not include the PORT.
                </note>

                <example><ex>:add-proxy localhost:40440</ex></example>

                <example><ex>:add-proxy /usr/home/blott/.proxy.pac</ex></example>

                <example><ex>:add-proxy http://wwwproxy.computing.dcu.ie</ex></example>

            </description>
        </item>

        <item>
            <tags>:sp :set-proxy</tags>
            <spec>:set-proxy <a>direct|auto|system</a></spec>
            <spec>:set-proxy <a>index</a></spec>
            <spec>:set-proxy <a>manual-URI</a> <oa>exclusions</oa></spec>
            <spec>:set-proxy <a>PAC-URI</a></spec>
            <spec>:set-proxy -quiet <a>other arguments...</a></spec>
            <description>
                <p>
                    Set the active proxy to be that indicated by the argument
                    or arguments.
                </p>

                <p>
                    If the argument is
                    <str>direct</str>,
                    then a direct connection is used;
                    if the argument is
                    <str>auto</str>,
                    then proxy settings are automatically detected; and
                    if the argument is
                    <str>system</str>,
                    then the system's settings are used.
                </p>

                <p>
                    If the argument is an <a>index</a>, then it is
                    taken to be the index (within the list of known proxies) of
                    the proxy to activate.  The available indices are shown via
                    command completion, or can be listed using the
                    <ex>:show-proxies</ex> command.
                </p>

                <p>
                    In the latter two forms (in which a URI is provided
                            directly on the command line) <ex>:set-proxy</ex>
                    accepts the same argument forms as <ex>:add-proxy</ex>.
                    The given proxy is made active and appended to the list of
                    available proxies (if it is not already on the list).
                </p>

                <p>
                    Normally, <ex>:set-proxy</ex> echos the new proxy setting
                    in the status line.  If its first argument is
                    <str>-quiet</str> (or any non-empty prefix thereof), then
                    it does not do so.  This can be used, for example, to shut <ex>:set-proxy</ex> up
                    when used in the <t>pentadactylrc</t> file.
                </p>

                <p>
                    Whenever <ex>:set-proxy</ex> changes the proxy settings,
                    if the previously-active proxy setting is a manually-configured
                    proxy or a PAC file and it is not aleady on the list of
                    available proxies, then <ex>:set-proxy</ex> silently
                    adds it to the list.  To help ensure that manually-added entries
                    are positioned predictably within the list, entries so added
                    stick to the end of the list.
                </p>

                <example><ex>:set-proxy direct</ex></example>
                <p> Use a direct internet connection. </p>

                <example><ex>:set-proxy 3</ex></example>
                <p> Use the proxy at index <str>3</str>
                in the list of available proxies,
                whatever it may happen to be.
                </p>

                <example><ex>:set-proxy -quiet 0</ex></example>
                <p> Use the proxy at index <str>0</str>, and keep quiet about it.
                </p>

                <example><ex>:set-proxy http://localhost:40440/</ex></example>

                <example><ex>:set-proxy http://wwwproxy.computing.dcu.ie:8000/ localhost dcu.ie</ex></example>

                <example><ex>:set-proxy http://www.computing.dcu.ie/proxy.pac</ex></example>
            </description>
        </item>

        <item>
            <tags>:rp :remove-proxy</tags>
            <spec>:remove-proxy <a>index</a></spec>
            <description>
                <p>
                    Remove an entry from the list of available proxies.  The
                    available indices are shown via command completion, or can
                    be listed using the <ex>:show-proxies</ex> command.
                </p>
            </description>
        </item>

        <item>
            <tags>:spxs :show-proxies</tags>
            <spec>:show-proxies</spec>
            <description>
                <p>
                    Display a list of available proxies and their
                    indices.  These index values can be used as arguments to
                    <ex>:set-proxy</ex> and <ex>:remove-proxy</ex>.
                </p>
            </description>
        </item>

        <item>
            <tags>:spx :show-proxy</tags>
            <spec>:show-proxy</spec>
            <description>
                <p>
                    Display information about the currenty-active proxy
                    settings.  This information is extracted directly from
                    Firefox, so it should be accurate.
                </p>
            </description>
        </item>

        <note>
            The same manually-configured proxy is shared across all protocols;
            there is currently no way here to specify separate proxies for different
            protocols.
        </note>

        <note>
            The list of available proxies is not retained between
            Firefox/Pentadactyl sessions.  So it may be best to ensure that all
            important proxies settings are added in the <t>pentadactylrc</t>
            file.  On the other hand, interactive commands are always recorded
            in the command history, so you can always re-run them from there.
        </note>

    </plugin>;
*/
/* vim:se sts=4 sw=4 et: */

