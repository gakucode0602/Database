mw.loader.implement("u:dev:MediaWiki:I18n-js/code.js@1la5j", function($, jQuery, require, module) {
    (function(window, $, mw, undefined) {
        'use strict';
        window.dev = window.dev || {};
        window.dev.i18n = window.dev.i18n || {};
        if (window.dev.i18n.loadMessages !== undefined) {
            return;
        }
        var conf = mw.config.get(['debug', 'wgContentLanguage', 'wgPageContentLanguage', 'wgPageContentModel', 'wgUserLanguage', 'wgUserVariant'])
          , now = Date.now()
          , oneDay = 1000 * 60 * 60 * 24
          , cachePrefix = 'i18n-cache-'
          , warnedAboutFallbackLoop = false
          , cache = {}
          , overrides = null
          , deprecatedCodes = {
            'als': 'gsw',
            'bat-smg': 'sgs',
            'be-x-old': 'be-tarask',
            'fiu-vro': 'vro',
            'roa-rup': 'rup',
            'zh-classical': 'lzh',
            'zh-min-nan': 'nan',
            'zh-yue': 'yue'
        }
          , nonStandardCodes = {
            'cbk-zam': 'cbk',
            'crh-ro': 'crh-Latn-RO',
            'de-formal': 'de-x-formal',
            'eml': 'egl',
            'en-rtl': 'en-x-rtl',
            'es-formal': 'es-x-formal',
            'hu-formal': 'hu-x-formal',
            'kk-cn': 'kk-Arab-CN',
            'kk-tr': 'kk-Latn-TR',
            'map-bms': 'jv-x-bms',
            'mo': 'ro-Cyrl-MD',
            'nrm': 'nrf',
            'nl-informal': 'nl-x-informal',
            'roa-tara': 'nap-x-tara',
            'simple': 'en-simple',
            'sr-ec': 'sr-Cyrl',
            'sr-el': 'sr-Latn',
            'zh-cn': 'zh-Hans-CN',
            'zh-sg': 'zh-Hans-SG',
            'zh-my': 'zh-Hans-MY',
            'zh-tw': 'zh-Hant-TW',
            'zh-hk': 'zh-Hant-HK',
            'zh-mo': 'zh-Hant-MO'
        }
          , fallbacks = {
            'ab': ['ru'],
            'abs': ['id'],
            'ace': ['id'],
            'acm': ['ar'],
            'ady': ['ady-cyrl'],
            'aeb': ['aeb-arab'],
            'aeb-arab': ['ar'],
            'aln': ['sq'],
            'alt': ['ru'],
            'ami': ['zh-tw', 'zh-hant', 'zh', 'zh-hans'],
            'an': ['es'],
            'anp': ['hi'],
            'arn': ['es'],
            'arq': ['ar'],
            'ary': ['ar'],
            'arz': ['ar'],
            'ast': ['es'],
            'atj': ['fr'],
            'av': ['ru'],
            'avk': ['fr', 'es', 'ru'],
            'awa': ['hi'],
            'ay': ['es'],
            'azb': ['fa'],
            'ba': ['ru'],
            'ban': ['id'],
            'ban-bali': ['ban'],
            'bar': ['de'],
            'bbc': ['bbc-latn'],
            'bbc-latn': ['id'],
            'bcc': ['fa'],
            'bci': ['fr'],
            'be-tarask': ['be'],
            'bgn': ['fa'],
            'bh': ['bho'],
            'bjn': ['id'],
            'blk': ['my'],
            'bm': ['fr'],
            'bpy': ['bn'],
            'bqi': ['fa'],
            'btm': ['id'],
            'bug': ['id'],
            'bxr': ['ru'],
            'ca': ['oc'],
            'cbk-zam': ['es'],
            'cdo': ['nan', 'zh-hant', 'zh', 'zh-hans'],
            'ce': ['ru'],
            'co': ['it'],
            'crh': ['crh-latn'],
            'crh-cyrl': ['ru'],
            'crh-ro': ['ro'],
            'cs': ['sk'],
            'csb': ['pl'],
            'cv': ['ru'],
            'de-at': ['de'],
            'de-ch': ['de'],
            'de-formal': ['de'],
            'dsb': ['hsb', 'de'],
            'dtp': ['ms'],
            'dty': ['ne'],
            'egl': ['it'],
            'eml': ['it'],
            'es-formal': ['es'],
            'ext': ['es'],
            'fit': ['fi'],
            'fon': ['fr'],
            'frc': ['fr'],
            'frp': ['fr'],
            'frr': ['de'],
            'fur': ['it'],
            'gag': ['tr'],
            'gan': ['gan-hant', 'gan-hans', 'zh-hant', 'zh', 'zh-hans'],
            'gan-hans': ['gan', 'gan-hant', 'zh-hans', 'zh', 'zh-hant'],
            'gan-hant': ['gan', 'gan-hans', 'zh-hant', 'zh', 'zh-hans'],
            'gcr': ['fr'],
            'gl': ['pt'],
            'gld': ['ru'],
            'glk': ['fa'],
            'gn': ['es'],
            'gom': ['gom-deva', 'gom-latn'],
            'gom-deva': ['gom-latn'],
            'gor': ['id'],
            'gsw': ['de'],
            'guc': ['es'],
            'hak': ['zh-hant', 'zh', 'zh-hans'],
            'hif': ['hif-latn'],
            'hrx': ['de'],
            'hsb': ['dsb', 'de'],
            'hsn': ['zh-cn', 'zh-hans', 'zh', 'zh-hant'],
            'ht': ['fr'],
            'hu-formal': ['hu'],
            'hyw': ['hy'],
            'ii': ['zh-cn', 'zh-hans', 'zh', 'zh-hant'],
            'ike-cans': ['iu'],
            'ike-latn': ['iu'],
            'inh': ['ru'],
            'io': ['eo'],
            'iu': ['ike-cans'],
            'jut': ['da'],
            'jv': ['id'],
            'kaa': ['kk-latn', 'kk-cyrl'],
            'kab': ['fr'],
            'kbd': ['kbd-cyrl'],
            'kbp': ['fr'],
            'kea': ['pt'],
            'khw': ['ur'],
            'kiu': ['tr'],
            'kjh': ['ru'],
            'kjp': ['my'],
            'kk': ['kk-cyrl'],
            'kk-arab': ['kk', 'kk-cyrl'],
            'kk-cn': ['kk-arab', 'kk', 'kk-cyrl'],
            'kk-cyrl': ['kk'],
            'kk-kz': ['kk-cyrl', 'kk'],
            'kk-latn': ['kk', 'kk-cyrl'],
            'kk-tr': ['kk-latn', 'kk', 'kk-cyrl'],
            'kl': ['da'],
            'ko-kp': ['ko'],
            'koi': ['ru'],
            'krc': ['ru'],
            'krl': ['fi'],
            'ks': ['ks-arab'],
            'ksh': ['de'],
            'ksw': ['my'],
            'ku': ['ku-latn'],
            'ku-arab': ['ku', 'ckb'],
            'ku-latn': ['ku'],
            'kum': ['ru'],
            'kv': ['ru'],
            'lad': ['es'],
            'lb': ['de'],
            'lbe': ['ru'],
            'lez': ['ru', 'az'],
            'li': ['nl'],
            'lij': ['it'],
            'liv': ['et'],
            'lki': ['fa'],
            'lld': ['it', 'rm', 'fur'],
            'lmo': ['pms', 'eml', 'lij', 'vec', 'it'],
            'ln': ['fr'],
            'lrc': ['fa'],
            'ltg': ['lv'],
            'luz': ['fa'],
            'lzh': ['zh-hant', 'zh', 'zh-hans'],
            'lzz': ['tr'],
            'mad': ['id'],
            'mag': ['hi'],
            'mai': ['hi'],
            'map-bms': ['jv', 'id'],
            'mdf': ['myv', 'ru'],
            'mg': ['fr'],
            'mhr': ['mrj', 'ru'],
            'min': ['id'],
            'mnw': ['my'],
            'mo': ['ro'],
            'mrj': ['mhr', 'ru'],
            'ms-arab': ['ms'],
            'mwl': ['pt'],
            'myv': ['mdf', 'ru'],
            'mzn': ['fa'],
            'nah': ['es'],
            'nan': ['cdo', 'zh-hant', 'zh', 'zh-hans'],
            'nap': ['it'],
            'nb': ['no', 'nn'],
            'nds': ['de'],
            'nds-nl': ['nl'],
            'nia': ['id'],
            'nl-informal': ['nl'],
            'nn': ['no', 'nb'],
            'no': ['nb'],
            'nrm': ['nrf', 'fr'],
            'oc': ['ca', 'fr'],
            'olo': ['fi'],
            'os': ['ru'],
            'pcd': ['fr'],
            'pdc': ['de'],
            'pdt': ['de'],
            'pfl': ['de'],
            'pms': ['it'],
            'pnt': ['el'],
            'pt': ['pt-br'],
            'pt-br': ['pt'],
            'pwn': ['zh-tw', 'zh-hant', 'zh', 'zh-hans'],
            'qu': ['qug', 'es'],
            'qug': ['qu', 'es'],
            'rgn': ['it'],
            'rmy': ['ro'],
            'roa-tara': ['it'],
            'rsk': ['sr-cyrl', 'sr-ec'],
            'rue': ['uk', 'ru'],
            'rup': ['ro'],
            'ruq': ['ruq-latn', 'ro'],
            'ruq-cyrl': ['mk'],
            'ruq-latn': ['ro'],
            'sa': ['hi'],
            'sah': ['ru'],
            'scn': ['it'],
            'sdc': ['it'],
            'sdh': ['cbk', 'fa'],
            'se': ['nb', 'fi'],
            'se-fi': ['se', 'fi', 'sv'],
            'se-no': ['se', 'nb', 'nn'],
            'se-se': ['se', 'sv'],
            'ses': ['fr'],
            'sg': ['fr'],
            'sgs': ['lt'],
            'sh': ['sh-latn', 'sh-cyrl', 'bs', 'sr-latn', 'sr-el', 'hr'],
            'sh-cyrl': ['sr-cyrl', 'sr-ec', 'sh', 'sh-latn'],
            'sh-latn': ['sh', 'sh-cyrl', 'bs', 'sr-latn', 'sr-el', 'hr'],
            'shi': ['shi-latn', 'fr'],
            'shi-latn': ['shi', 'fr'],
            'shi-tfng': ['shi', 'shi-latn', 'fr'],
            'shy': ['shy-latn'],
            'shy-latn': ['fr'],
            'sjd': ['ru'],
            'sk': ['cs'],
            'skr': ['skr-arab'],
            'skr-arab': ['skr'],
            'sli': ['de'],
            'sma': ['sv', 'nb'],
            'smn': ['fi'],
            'sr': ['sr-cyrl', 'sr-ec'],
            'sr-cyrl': ['sr-ec', 'sr'],
            'sr-ec': ['sr-cyrl', 'sr'],
            'sr-el': ['sr-latn', 'sr'],
            'sr-latn': ['sr-el', 'sr'],
            'srn': ['nl'],
            'sro': ['it'],
            'stq': ['de'],
            'sty': ['ru'],
            'su': ['id'],
            'szl': ['pl'],
            'szy': ['zh-tw', 'zh-hant', 'zh', 'zh-hans'],
            'tay': ['zh-tw', 'zh-hant', 'zh', 'zh-hans'],
            'tcy': ['kn'],
            'tet': ['pt'],
            'tg': ['tg-cyrl'],
            'tg-cyrl': ['tg'],
            'tg-latn': ['tg', 'tg-cyrl'],
            'trv': ['zh-tw', 'zh-hant', 'zh', 'zh-hans'],
            'tt': ['tt-cyrl', 'ru'],
            'tt-cyrl': ['ru'],
            'ty': ['fr'],
            'tyv': ['ru'],
            'udm': ['ru'],
            'ug': ['ug-arab'],
            'vec': ['it'],
            'vep': ['et'],
            'vls': ['nl'],
            'vmf': ['de'],
            'vmw': ['pt'],
            'vot': ['fi'],
            'vro': ['et'],
            'wa': ['fr'],
            'wls': ['fr'],
            'wo': ['fr'],
            'wuu': ['wuu-hans', 'wuu-hant', 'zh-hans', 'zh', 'zh-hant'],
            'wuu-hans': ['wuu', 'wuu-hant', 'zh-hans', 'zh', 'zh-hant'],
            'wuu-hant': ['wuu', 'wuu-hans', 'zh-hant', 'zh', 'zh-hans'],
            'xal': ['ru'],
            'xmf': ['ka'],
            'yi': ['he'],
            'yue': ['yue-hant', 'yue-hans'],
            'yue-hans': ['yue', 'yue-hant'],
            'yue-hant': ['yue', 'yue-hans'],
            'za': ['zh-hans', 'zh', 'zh-hant'],
            'zea': ['nl'],
            'zgh': ['kab'],
            'zh': ['zh-hans', 'zh-hant', 'zh-cn', 'zh-tw', 'zh-hk'],
            'zh-cn': ['zh-hans', 'zh', 'zh-hant'],
            'zh-hans': ['zh-cn', 'zh', 'zh-hant'],
            'zh-hant': ['zh-tw', 'zh-hk', 'zh', 'zh-hans'],
            'zh-hk': ['zh-hant', 'zh-tw', 'zh', 'zh-hans'],
            'zh-mo': ['zh-hk', 'zh-hant', 'zh-tw', 'zh', 'zh-hans'],
            'zh-my': ['zh-sg', 'zh-hans', 'zh-cn', 'zh', 'zh-hant'],
            'zh-sg': ['zh-hans', 'zh-cn', 'zh', 'zh-hant'],
            'zh-tw': ['zh-hant', 'zh-hk', 'zh', 'zh-hans']
        };
        if (conf.wgPageContentModel && conf.wgPageContentModel !== 'wikitext') {
            conf.wgPageContentLanguage = conf.wgContentLanguage;
        }
        function bcp47(lang) {
            if (nonStandardCodes[lang]) {
                return nonStandardCodes[lang];
            }
            if (deprecatedCodes[lang]) {
                return bcp47(deprecatedCodes[lang]);
            }
            var formatted, isFirstSegment = true, isPrivate = false, segments = lang.split('-');
            formatted = segments.map(function(segment) {
                var newSegment;
                if (isPrivate) {
                    newSegment = segment.toLowerCase();
                } else if (segment.length === 2 && !isFirstSegment) {
                    newSegment = segment.toUpperCase();
                } else if (segment.length === 4 && !isFirstSegment) {
                    newSegment = segment.charAt(0).toUpperCase() + segment.substring(1).toLowerCase();
                } else {
                    newSegment = segment.toLowerCase();
                }
                isPrivate = segment.toLowerCase() === 'x';
                isFirstSegment = false;
                return newSegment;
            });
            return formatted.join('-');
        }
        function warnOnFallbackLoop(lang, fallbackChain) {
            if (warnedAboutFallbackLoop) {
                return;
            }
            warnedAboutFallbackLoop = true;
            fallbackChain.push(lang);
            console.error('[I18n-js] Duplicated fallback language found. Please leave a message at <https://dev.fandom.com/wiki/Talk:I18n-js> and include the following line: \nLanguage fallback chain:', fallbackChain.join(', '));
        }
        function getMsg(messages, msgName, lang, fallbackChain) {
            if (!lang || !messages || !msgName) {
                return false;
            }
            if (deprecatedCodes[lang]) {
                return getMsg(messages, msgName, deprecatedCodes[lang], fallbackChain);
            }
            if (messages[lang] && messages[lang][msgName]) {
                return messages[lang][msgName];
            }
            if (!fallbackChain) {
                fallbackChain = [];
            }
            for (var i = 0; (fallbacks[lang] && i < fallbacks[lang].length); i += 1) {
                var fallbackLang = fallbacks[lang][i];
                if (messages[fallbackLang] && messages[fallbackLang][msgName]) {
                    return messages[fallbackLang][msgName];
                }
                if (fallbackChain.indexOf(fallbackLang) !== -1) {
                    warnOnFallbackLoop(fallbackLang, fallbackChain);
                    continue;
                }
                fallbackChain.push(fallbackLang);
            }
            if (messages.en && messages.en[msgName]) {
                return messages.en[msgName];
            }
            return false;
        }
        function handleArgs(message, args) {
            args.forEach(function(elem, index) {
                var rgx = new RegExp('\\$' + (index + 1),'g');
                message = message.replace(rgx, elem);
            });
            return message;
        }
        function makeLink(href, text, hasProtocol) {
            text = text || href;
            href = hasProtocol ? href : mw.util.getUrl(href);
            text = mw.html.escape(text);
            href = mw.html.escape(href);
            return '<a href="' + href + '" title="' + text + '">' + text + '</a>';
        }
        function sanitiseHtml(html) {
            var context = document.implementation.createHTMLDocument('')
              , $html = $.parseHTML(html, context, false)
              , $div = $('<div>', context).append($html)
              , allowedAttrs = ['title', 'style', 'class']
              , allowedTags = ['i', 'b', 's', 'br', 'em', 'strong', 'span', ];
            $div.find('*').each(function() {
                var $this = $(this), tagname = $this.prop('tagName').toLowerCase(), attrs, array, style;
                if (allowedTags.indexOf(tagname) === -1) {
                    mw.log('[I18n-js] Disallowed tag in message: ' + tagname);
                    $this.remove();
                    return;
                }
                attrs = $this.prop('attributes');
                array = Array.prototype.slice.call(attrs);
                array.forEach(function(attr) {
                    if (allowedAttrs.indexOf(attr.name) === -1) {
                        mw.log('[I18n-js] Disallowed attribute in message: ' + attr.name + ', tag: ' + tagname);
                        $this.removeAttr(attr.name);
                        return;
                    }
                    if (attr.name === 'style') {
                        style = $this.attr('style');
                        if (style.indexOf('url(') > -1) {
                            mw.log('[I18n-js] Disallowed url() in style attribute');
                            $this.removeAttr('style');
                        } else if (style.indexOf('var(') > -1) {
                            mw.log('[I18n-js] Disallowed var() in style attribute');
                            $this.removeAttr('style');
                        }
                    }
                });
            });
            return $div.prop('innerHTML');
        }
        function parse(message) {
            var urlRgx = /\[((?:https?:)?\/\/.+?) (.+?)\]/g
              , simplePageRgx = /\[\[([^|]*?)\]\]/g
              , pageWithTextRgx = /\[\[(.+?)\|(.+?)\]\]/g
              , pluralRgx = /\{\{PLURAL:(\d+)\|(.+?)\}\}/gi
              , genderRgx = /\{\{GENDER:([^|]+)\|(.+?)\}\}/gi;
            if (message.indexOf('<') > -1) {
                message = sanitiseHtml(message);
            }
            return message.replace(urlRgx, function(_match, href, text) {
                return makeLink(href, text, true);
            }).replace(simplePageRgx, function(_match, href) {
                return makeLink(href);
            }).replace(pageWithTextRgx, function(_match, href, text) {
                return makeLink(href, text);
            }).replace(pluralRgx, function(_match, count, forms) {
                return mw.language.convertPlural(Number(count), forms.split('|'));
            }).replace(genderRgx, function(_match, gender, forms) {
                return mw.language.gender(gender, forms.split('|'));
            });
        }
        function message(messages, lang, args, name) {
            if (!args.length) {
                return;
            }
            var msgName = args.shift()
              , descriptiveMsgName = 'i18njs-' + name + '-' + msgName
              , msg = getMsg(messages, msgName, lang)
              , msgExists = msg !== false;
            if (!msgExists) {
                msg = '<' + descriptiveMsgName + '>';
            }
            if (conf.wgUserLanguage === 'qqx' && msgExists) {
                msg = '(' + descriptiveMsgName + ')';
            } else if (overrides[name] && overrides[name][msgName]) {
                msg = overrides[name][msgName];
                msgExists = true;
            }
            if (args.length) {
                msg = handleArgs(msg, args);
            }
            return {
                exists: msgExists,
                parse: function() {
                    if (!this.exists) {
                        return this.escape();
                    }
                    return parse(msg);
                },
                escape: function() {
                    return mw.html.escape(msg);
                },
                plain: function() {
                    return msg;
                }
            };
        }
        function i18n(messages, name, options) {
            var defaultLang = options.language
              , tempLang = null;
            return {
                useLang: function() {
                    console.warn('[I18n-js] “useLang()” is no longer supported by I18n-js (used in “' + name + '”) - using user language.');
                    this.useUserLang();
                },
                inLang: function(lang) {
                    if (!options.cacheAll) {
                        console.warn('[I18n-js] “inLang()” is not supported without configuring `options.cacheAll` (used in “' + name + '”) - using user language.');
                        lang = options.language;
                    }
                    tempLang = lang;
                    return this;
                },
                useContentLang: function() {
                    defaultLang = conf.wgContentLanguage;
                },
                inContentLang: function() {
                    tempLang = conf.wgContentLanguage;
                    return this;
                },
                usePageLang: function() {
                    defaultLang = conf.wgPageContentLanguage;
                },
                inPageLang: function() {
                    tempLang = conf.wgPageContentLanguage;
                    return this;
                },
                usePageViewLang: function() {
                    defaultLang = conf.wgUserVariant || conf.wgPageContentLanguage || conf.wgContentLanguage;
                },
                inPageViewLang: function() {
                    tempLang = conf.wgUserVariant || conf.wgPageContentLanguage || conf.wgContentLanguage;
                    return this;
                },
                useUserLang: function() {
                    defaultLang = options.language;
                },
                inUserLang: function() {
                    tempLang = options.language;
                    return this;
                },
                msg: function() {
                    var args = Array.prototype.slice.call(arguments)
                      , lang = defaultLang;
                    if (tempLang !== null) {
                        lang = tempLang;
                        tempLang = null;
                    }
                    return message(messages, lang, args, name);
                },
                _messages: messages
            };
        }
        function optimiseMessages(name, messages, options) {
            var existingLangs = cache[name] && cache[name]._messages._isOptimised
              , langs = [options.language]
              , msgKeys = Object.keys(messages.en || {})
              , optimised = {};
            if (!msgKeys.length) {
                return messages;
            }
            var addMsgsForLanguage = function(lang) {
                if (optimised[lang]) {
                    return;
                }
                optimised[lang] = {};
                msgKeys.forEach(function(msgName) {
                    var msg = getMsg(messages, msgName, lang);
                    if (msg !== false) {
                        optimised[lang][msgName] = msg;
                    }
                });
            };
            if (langs.indexOf(conf.wgContentLanguage) === -1) {
                langs.push(conf.wgContentLanguage);
            }
            if (existingLangs) {
                existingLangs.forEach(function(lang) {
                    if (langs.indexOf(lang) === -1) {
                        langs.push(lang);
                    }
                });
            }
            langs.forEach(addMsgsForLanguage);
            if (Array.isArray(options.cacheAll)) {
                msgKeys = options.cacheAll;
                Object.keys(messages).forEach(addMsgsForLanguage);
            }
            optimised._isOptimised = langs;
            return optimised;
        }
        function cacheIsSuitable(name, options) {
            var messages = cache[name] && cache[name]._messages;
            if (!messages) {
                return false;
            }
            if (messages._isOptimised && !(messages[options.language] && messages[conf.wgContentLanguage])) {
                return false;
            }
            return true;
        }
        function removeOldCacheEntries() {
            var isCacheKey = new RegExp('^(' + cachePrefix + '.+)-content$')
              , storageKeys = [];
            try {
                storageKeys = Object.keys(localStorage);
            } catch (e) {}
            storageKeys.filter(function(key) {
                return isCacheKey.test(key);
            }).forEach(function(key) {
                var keyPrefix = key.match(isCacheKey)[1], cacheTimestamp;
                try {
                    cacheTimestamp = Number(localStorage.getItem(keyPrefix + '-timestamp'));
                } catch (e) {}
                if (now - cacheTimestamp < oneDay * 2) {
                    return;
                }
                try {
                    localStorage.removeItem(keyPrefix + '-content');
                    localStorage.removeItem(keyPrefix + '-timestamp');
                    localStorage.removeItem(keyPrefix + '-version');
                } catch (e) {}
            });
        }
        function stripComments(json) {
            json = json.trim().replace(/\/\*[\s\S]*?\*\//g, '');
            return json;
        }
        function saveToCache(name, json, cacheVersion) {
            var keyPrefix = cachePrefix + name;
            if (Object.keys(json).length === 0) {
                return;
            }
            try {
                localStorage.setItem(keyPrefix + '-content', JSON.stringify(json));
                localStorage.setItem(keyPrefix + '-timestamp', now);
                localStorage.setItem(keyPrefix + '-version', cacheVersion || 0);
            } catch (e) {}
        }
        function parseMessagesToObject(name, res, options) {
            var json = {}, obj, msg;
            try {
                res = stripComments(res);
                json = JSON.parse(res);
            } catch (e) {
                msg = e.message;
                if (msg === 'Unexpected end of JSON input') {
                    msg += '. This may be caused by a non-existent i18n.json page.';
                }
                console.warn('[I18n-js] SyntaxError in messages: ' + msg);
            }
            if (options.useCache && !options.loadedFromCache && options.cacheAll !== true) {
                json = optimiseMessages(name, json, options);
            }
            obj = i18n(json, name, options);
            cache[name] = obj;
            if (!options.loadedFromCache) {
                saveToCache(name, json, options.cacheVersion);
            }
            return obj;
        }
        function loadFromCache(name, options) {
            var keyPrefix = cachePrefix + name, cacheContent, cacheVersion;
            try {
                cacheContent = localStorage.getItem(keyPrefix + '-content');
                cacheVersion = Number(localStorage.getItem(keyPrefix + '-version'));
            } catch (e) {}
            if (cacheContent && cacheVersion >= options.cacheVersion) {
                options.loadedFromCache = true;
                parseMessagesToObject(name, cacheContent, options);
            }
        }
        function loadMessages(name, options) {
            var deferred = $.Deferred(), customSource = name.match(/^u:(?:([a-z-]+)\.)?([a-z0-9-]+):/), apiEndpoint = 'https://dev.fandom.com/api.php', apiEndpointRgx = new RegExp('^(https:\/\/(([a-z0-9-]+)\.fandom\.com(?:\/([a-z-]+))?)\/api\.php)$'), page = 'MediaWiki:Custom-' + name + '/i18n.json', params;
            options = options || {};
            if (options.apiEndpoint && apiEndpointRgx.test(options.apiEndpoint)) {
                options.apiEndpoint = options.apiEndpoint;
            } else {
                options.apiEndpoint = apiEndpoint;
            }
            options.page = (options.page && options.page.replace(/\$1/g, name)) || page;
            options.cacheVersion = Number(options.cacheVersion) || 0;
            options.language = options.language || conf.wgUserLanguage;
            options.useCache = (options.noCache || conf.debug) !== true;
            if (options.useCache) {
                loadFromCache(name, options);
                if (cacheIsSuitable(name, options)) {
                    return deferred.resolve(cache[name]);
                }
            }
            options.loadedFromCache = false;
            if (customSource) {
                apiEndpoint = apiEndpoint.replace('dev', customSource[2]);
                page = name.slice(customSource[0].length);
                if (customSource[1]) {
                    apiEndpoint = apiEndpoint.replace(/api\.php$/, customSource[1] + '/$&');
                }
            }
            params = {
                action: 'query',
                format: 'json',
                prop: 'revisions',
                rvprop: 'content',
                rvslots: 'main',
                titles: page,
                indexpageids: 1,
                origin: '*',
                maxage: 300,
                smaxage: 300
            };
            mw.loader.using(['mediawiki.language', 'mediawiki.util'], function() {
                $.ajax(apiEndpoint, {
                    data: params,
                }).always(function(data) {
                    var res = ''
                      , revisionData = data.query && data.query.pages[data.query.pageids[0]].revisions;
                    if (revisionData) {
                        res = revisionData[0].slots.main['*'];
                    }
                    deferred.resolve(parseMessagesToObject(name, res, options));
                });
            });
            return deferred;
        }
        window.dev.i18n = $.extend(window.dev.i18n, {
            loadMessages: loadMessages,
            _bcp47: bcp47,
            _stripComments: stripComments,
            _saveToCache: saveToCache,
            _getMsg: getMsg,
            _handleArgs: handleArgs,
            _parse: parse,
            _fallbacks: fallbacks,
            _cache: cache
        });
        window.dev.i18n.overrides = window.dev.i18n.overrides || {};
        overrides = window.dev.i18n.overrides;
        mw.hook('dev.i18n').fire(window.dev.i18n);
        removeOldCacheEntries();
    }(this, jQuery, mediaWiki));
}, {
    "css": []
});
