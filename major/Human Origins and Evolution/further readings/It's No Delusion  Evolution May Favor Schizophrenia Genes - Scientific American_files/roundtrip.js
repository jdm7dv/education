window.__adroll||(function(){function m(){this.exp=5E4;this.eexp=720;this.pv=1E11*Math.random();this.__adc="__ar_v4";this._nad=0;this._lce=null;this._loaded=this._broken=!1;this._url=2E3;this._kwl=300;this._r={};this._logs=[]};m.prototype.cookieEnabled=function(a){if(this._global("adroll_ext_network")||this._global("adroll_optout")||this._broken)return!1;if(2<=this._nad||a)return this._lce;this.set("_te_","1");return"1"===this.get("_te_")?(this.del("_te_"),0<this._nad&&!this.get(this.__adc)?this._lce=!1:this._lce=!0):this._lce=!1};
m.prototype.get=function(a){var b=window.document.cookie;if(null===b)return this._broken=!0,null;var c;0>b.indexOf(a+"=")?b=null:(a=b.indexOf(a+"=")+a.length+1,c=b.indexOf(";",a),-1===c&&(c=b.length),b=b.substring(a,c),b=""===b?null:window.unescape(b));return b};
m.prototype.set=function(a,b,c){var d;c&&"number"===typeof c?(d=new Date,d.setTime(d.getTime()+36E5*c),c=d.toGMTString(),c="; expires="+c):c="";d="; domain="+window.location.hostname;b=window.escape(b);window.document.cookie=a+"="+b+c+"; path=/"+d};m.prototype.del=function(a){this.set(a,"",-8760)};
m.prototype.check_cookie=function(a,b){if(this._global("adroll_ext_network")||this._global("adroll_optout"))return"";for(var c=a.split("|"),d=c.length-1;0<=d;d--)if(c[d]){var h=c[d].split(":");b===h[0]&&(h[2]=""+(parseInt(h[2])+1),c[d]=h.join(":"))}return c.join("|")};m.prototype.handle=function(a){var b=this.get(this.__adc)||"";-1!==b.indexOf(a)?this.set(this.__adc,this.check_cookie(b,a),this.exp):(a=[b,[a,this.get_date(this.eexp),"1"].join(":")].join("|"),this.set(this.__adc,a,this.exp))};
m.prototype.expire_old=function(){if(!this._global("adroll_ext_network")&&!this._global("adroll_optout")){for(var a=this.get_date(!1),b=this.get(this.__adc),b=b?b.split("|"):[""],c=[],d=b.length-1;0<=d;d--)b[d]&&b[d].split(":")[1]>a&&c.push(b[d]);this.set(this.__adc,c.join("|"),this.exp)}};m.prototype.get_date=function(a){var b=new Date;a&&b.setTime(b.getTime()+36E5*a);a=""+b.getUTCFullYear();var c=b.getUTCMonth(),c=10<=c?c:"0"+c,b=b.getUTCDate();return[a,c,10<=b?b:"0"+b].join("")};m.prototype.generate_link=function(){return""};m.prototype.view=function(a){var b=new window.Image;b.src=this._srv("/view/"+a);b.setAttribute("width","1");b.setAttribute("height","1");b.setAttribute("border","0");this._head().appendChild(b)};m.prototype.set_cookie=function(){};
m.prototype.reset=function(){this._set_global("adroll_c_id",null);this._set_global("adroll_url_macro","");this._set_global("adroll_c_macro","");this._set_global("adroll_cpm_macro","");this._set_global("adroll_ext_network",null);this._set_global("adroll_subnetwork",null);this._set_global("adroll_ad_payload",null);this._set_global("adroll_win_notif",null)};m.prototype.set_pixel_cookie=function(a,b,c){this._global("adroll_optout")||(this.handle(a),this.handle(b),this.handle(c),this.pixel_loaded())};
m.prototype.add_pixel_load_callback=function(a){this._loaded?a():this._ensure_global("adroll_callbacks",[]).push(a)};m.prototype.pixel_loaded=function(){this._loaded=!0;for(var a=this._ensure_global("adroll_callbacks",[]),b=0;b<a.length;b++)a[b].called||(a[b](),a[b].called=!0)};m.prototype.addLoadEvent=function(a){if(this._has_global("__adroll_loaded")&&this._global("__adroll_loaded")||this._has_global("_adroll_ie")&&this._global("_adroll_ie")||/msie/i.test(window.navigator.userAgent))return a();if(/WebKit/i.test(window.navigator.userAgent)){var b=window.setInterval(function(){/loaded|complete/.test(window.document.readyState)&&window.clearInterval(b);a()},10);return null}var c=window.onload;window.onload=function(){a();c&&c()}};
m.prototype._head=function(){return(window.document.getElementsByTagName("head")||[null])[0]||(window.document.getElementsByTagName("body")||[null])[0]||window.document.getElementsByTagName("script")[0].parentNode};m.prototype.external_data_to_qs=function(a){var b=[],c=this.get_external_data();if(!c)return null;for(var d in c)c.hasOwnProperty(d)&&this._is_defined(c[d])&&null!==c[d]&&b.push(this.normalize_var(window.escape(""+d)+"="+window.escape(""+c[d]),!1));b=b.join("&");a&&(b=window.escape(b));return"adroll_external_data="+b};
m.prototype.replace_external_data=function(a){var b=this.get_external_data(),c=this.get_conversion_value(),d=null,h;if(b)for(h in b)b.hasOwnProperty(h)&&(d=new RegExp("\\["+h+"\\]","gi"),a=a.replace(d,b[h]),d=new RegExp("\\["+h+"_ESC\\]","gi"),a=a.replace(d,window.escape(b[h])));if(c)for(h in c)c.hasOwnProperty(h)&&(d=new RegExp("\\["+h+"\\]","gi"),a=a.replace(d,c[h]),d=new RegExp("\\["+h+"_ESC\\]","gi"),a=a.replace(d,window.escape(c[h])));return a};
m.prototype.get_external_data=function(){if(this._has_global("adroll_custom_data")){var a=this._global("adroll_custom_data"),b={},c;for(c in a)a.hasOwnProperty(c)&&"undefined"!==a[c]&&(b[c.toLowerCase()]=a[c]);return b}return null};
m.prototype.get_conversion_value=function(){var a=this._ensure_global("adroll_currency",null),b=this._ensure_global("adroll_conversion_value",null),c=this._ensure_global("adroll_conversion_value_in_dollars",null);return b?{conv_value:""+b,currency:a}:c?{conv_value:""+parseInt(100*c),currency:"USC"}:null};m.prototype._has_global=function(a){return this._is_defined(this._global(a))};m.prototype._global=function(a){return window[a]};m.prototype._set_global=function(a,b){window[a]=b};m.prototype._unset_global=function(a){delete window[a]};m.prototype._ensure_global=function(a,b){this._has_global(a)||this._set_global(a,b);return this._global(a)};m.prototype.jsonStringify=function(a){this.jsonStringifyFunc||this.initJsonStringify();return this.jsonStringifyFunc(a)};m.prototype.jsonParse=function(a){var b=this._global("JSON");return"function"===typeof b.parse?b.parse(a):eval("("+a+")")};
m.prototype.initJsonStringify=function(){var a=this._global("JSON");this.jsonStringifyFunc=a||a.stringify&&"function"===typeof a.stringify?a.stringify:function(){function a(b){return h[b]||"\\u"+(b.charCodeAt(0)+65536).toString(16).substr(1)}var c=Object.prototype.toString,d=Array.isArray||function(a){return"[object Array]"===c.call(a)},h={'"':'\\"',"\\":"\\\\","\b":"\\b","\f":"\\f","\n":"\\n","\r":"\\r","\t":"\\t"},n=/[\\"\u0000-\u001F\u2028\u2029]/g;return function q(k){if(null===k)return"null";
if("number"===typeof k)return isFinite(k)?k.toString():"null";if("boolean"===typeof k)return k.toString();if("object"===typeof k){if("function"===typeof k.toJSON)return q(k.toJSON());if(d(k)){for(var f="[",e=0;e<k.length;e++)f+=(e?", ":"")+q(k[e]);return f+"]"}if("[object Object]"===c.call(k)){f=[];for(e in k)k.hasOwnProperty(e)&&f.push(q(e)+": "+q(k[e]));return"{"+f.join(", ")+"}"}}return'"'+k.toString().replace(n,a)+'"'}}()};m.prototype.macro_values=function(){var a=this._ensure_global("adroll_cpm_macro",null),b=this._ensure_global("adroll_url_macro",null),c=this._ensure_global("adroll_c_macro",null),d=this._ensure_global("adroll_subnetwork",null),h=this._ensure_global("adroll_ad_payload",null),n=this._ensure_global("adroll_win_notif",null),p=this._ensure_global("adroll_rtb_dict",null),q={r:/^\$\{.*\}$/i,g:/^%%.*%%$/i,b:/^\[.*\]$/i,x:/^\$\{.*\}$/i,t:/INSERTCLICKTRACKER/}[this._global("adroll_ext_network")],q=this._is_defined(q)?
q:/CANNOT_MATCH_THIS/,k={};a&&!q.test(a)&&(k.adroll_cpm_macro=a);b&&!q.test(b)&&(k.adroll_url_macro=b);c&&!q.test(c)&&(k.adroll_c_macro=c);d&&!q.test(d)&&(k.adroll_subnetwork=d);h&&!q.test(h)&&(k.adroll_ad_payload=h);n&&!/^[|$]/.test(n)&&(k.adroll_win_notif=n);!p||"string"===typeof p&&/^[|$]/.test(p)||("string"===typeof p&&(p=this.jsonParse(p)),k.adroll_rtb_dict=p);return k};m.prototype.format_macros=function(a,b,c,d){return this.macro_url_params(this.macro_values(),a,b,c,d)};
m.prototype.macro_url_params=function(a,b,c,d,h){h=this._is_defined(h)?h:!1;var n=d?window.escape:function(a){return a},p=a.adroll_cpm_macro,q=a.adroll_url_macro,k=c?a.adroll_c_macro:null,f=[],e=b?this.parseUri(b):null,e=e?this.endswith(e.path,".tp"):!1;!e&&h&&f.push(["desturl",""]);k&&0===k.indexOf("http")?(h=n,"g"===this._global("adroll_ext_network")&&(h=d?function(a){return a}:window.unescape),f.push(["clickurl",h(k)])):e&&h&&f.push(["clickurl",""]);this._global("adroll_ext_network")&&f.push(["adroll_network",
this._global("adroll_ext_network")]);p&&f.push(["cpm",p]);a.adroll_subnetwork&&f.push(["adroll_subnetwork",a.adroll_subnetwork]);a.adroll_ad_payload&&f.push(["adroll_ad_payload",a.adroll_ad_payload]);q&&(a=this.parseUri(window.unescape(q)),f.push(["site_url",n("http://"+a.host)]),c&&(f.push(["adroll_width",n(this._global("adroll_width"))]),f.push(["adroll_height",n(this._global("adroll_height"))])));this.log("Macros found "+this.serialize(f));return b?this.buildurl(b,f):this.serialize(f)};
m.prototype.serialize=function(a){if(a.length){for(var b=[],c=a.length-1;0<=c;c--)b.push(a[c].join("="));return b.join("&")}return""};m.prototype.endswith=function(a,b){return-1!==a.indexOf(b,a.length-b.length)};m.prototype.buildurl=function(a,b){var c=this.serialize(b),d=a.indexOf("?");return c?d===a.length-1?a+c:-1!==d?"&"===a[a.length-1]?a+c:a+"&"+c:a+"?"+c:a};m.prototype.md5=function(){function a(a,b){var c=(a&65535)+(b&65535);return(a>>16)+(b>>16)+(c>>16)<<16|c&65535}function b(b,c,f,e,d,g){c=a(a(c,b),a(e,g));return a(c<<d|c>>>32-d,f)}function c(a,c,f,e,d,g,h){return b(c&f|~c&e,a,c,d,g,h)}function d(a,c,f,e,d,g,h){return b(c&e|f&~e,a,c,d,g,h)}function h(a,c,f,e,d,g,h){return b(f^(c|~e),a,c,d,g,h)}function n(n,k){var f=n[0],e=n[1],l=n[2],g=n[3],f=c(f,e,l,g,k[0],7,-680876936),g=c(g,f,e,l,k[1],12,-389564586),l=c(l,g,f,e,k[2],17,606105819),e=c(e,l,g,f,k[3],
22,-1044525330),f=c(f,e,l,g,k[4],7,-176418897),g=c(g,f,e,l,k[5],12,1200080426),l=c(l,g,f,e,k[6],17,-1473231341),e=c(e,l,g,f,k[7],22,-45705983),f=c(f,e,l,g,k[8],7,1770035416),g=c(g,f,e,l,k[9],12,-1958414417),l=c(l,g,f,e,k[10],17,-42063),e=c(e,l,g,f,k[11],22,-1990404162),f=c(f,e,l,g,k[12],7,1804603682),g=c(g,f,e,l,k[13],12,-40341101),l=c(l,g,f,e,k[14],17,-1502002290),e=c(e,l,g,f,k[15],22,1236535329),f=d(f,e,l,g,k[1],5,-165796510),g=d(g,f,e,l,k[6],9,-1069501632),l=d(l,g,f,e,k[11],14,643717713),e=d(e,
l,g,f,k[0],20,-373897302),f=d(f,e,l,g,k[5],5,-701558691),g=d(g,f,e,l,k[10],9,38016083),l=d(l,g,f,e,k[15],14,-660478335),e=d(e,l,g,f,k[4],20,-405537848),f=d(f,e,l,g,k[9],5,568446438),g=d(g,f,e,l,k[14],9,-1019803690),l=d(l,g,f,e,k[3],14,-187363961),e=d(e,l,g,f,k[8],20,1163531501),f=d(f,e,l,g,k[13],5,-1444681467),g=d(g,f,e,l,k[2],9,-51403784),l=d(l,g,f,e,k[7],14,1735328473),e=d(e,l,g,f,k[12],20,-1926607734),f=b(e^l^g,f,e,k[5],4,-378558),g=b(f^e^l,g,f,k[8],11,-2022574463),l=b(g^f^e,l,g,k[11],16,1839030562),
e=b(l^g^f,e,l,k[14],23,-35309556),f=b(e^l^g,f,e,k[1],4,-1530992060),g=b(f^e^l,g,f,k[4],11,1272893353),l=b(g^f^e,l,g,k[7],16,-155497632),e=b(l^g^f,e,l,k[10],23,-1094730640),f=b(e^l^g,f,e,k[13],4,681279174),g=b(f^e^l,g,f,k[0],11,-358537222),l=b(g^f^e,l,g,k[3],16,-722521979),e=b(l^g^f,e,l,k[6],23,76029189),f=b(e^l^g,f,e,k[9],4,-640364487),g=b(f^e^l,g,f,k[12],11,-421815835),l=b(g^f^e,l,g,k[15],16,530742520),e=b(l^g^f,e,l,k[2],23,-995338651),f=h(f,e,l,g,k[0],6,-198630844),g=h(g,f,e,l,k[7],10,1126891415),
l=h(l,g,f,e,k[14],15,-1416354905),e=h(e,l,g,f,k[5],21,-57434055),f=h(f,e,l,g,k[12],6,1700485571),g=h(g,f,e,l,k[3],10,-1894986606),l=h(l,g,f,e,k[10],15,-1051523),e=h(e,l,g,f,k[1],21,-2054922799),f=h(f,e,l,g,k[8],6,1873313359),g=h(g,f,e,l,k[15],10,-30611744),l=h(l,g,f,e,k[6],15,-1560198380),e=h(e,l,g,f,k[13],21,1309151649),f=h(f,e,l,g,k[4],6,-145523070),g=h(g,f,e,l,k[11],10,-1120210379),l=h(l,g,f,e,k[2],15,718787259),e=h(e,l,g,f,k[9],21,-343485551);n[0]=a(f,n[0]);n[1]=a(e,n[1]);n[2]=a(l,n[2]);n[3]=
a(g,n[3])}var p="0123456789abcdef".split("");return function(a){var b=a;/[\x80-\xFF]/.test(b)&&(b=unescape(encodeURI(b)));var c=b.length;a=[1732584193,-271733879,-1732584194,271733878];var e;for(e=64;e<=b.length;e+=64){for(var d=b.substring(e-64,e),g=[],h=void 0,h=0;64>h;h+=4)g[h>>2]=d.charCodeAt(h)+(d.charCodeAt(h+1)<<8)+(d.charCodeAt(h+2)<<16)+(d.charCodeAt(h+3)<<24);n(a,g)}b=b.substring(e-64);d=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];for(e=0;e<b.length;e++)d[e>>2]|=b.charCodeAt(e)<<(e%4<<3);d[e>>2]|=
128<<(e%4<<3);if(55<e)for(n(a,d),e=0;16>e;e++)d[e]=0;d[14]=8*c;n(a,d);for(b=0;b<a.length;b++){c=a;e=b;d=a[b];g="";for(h=0;4>h;h++)g+=p[d>>8*h+4&15]+p[d>>8*h&15];c[e]=g}return a.join("")}}();m.prototype._gurl=function(){var a=window.location;return this.normalize_url(a.pathname+a.search)};m.prototype.get_dummy_product_for_facebook=function(a){return{product_id:"adroll_dummy_product",product_group:a,product_action:null,product_category:null}};m.prototype.facebook_dummy_product_enabled=function(){return!0};
m.prototype.extract_pid=function(a,b,c){function d(a){return a?(a=new RegExp(a,"gi"),!!a.exec(k)):null}a||(a={});var h=null,n=null,p=null,q=null,k=this._gurl(),f=this.get_external_data();f&&(n=f.product_id,h=f.product_group,p=f.product_action,q=f.adroll_product_category_id);if(!n&&a.regexp_group&&!("string"===a.regexp_group&&a.regexp_group instanceof String)&&"html"===a.regexp_group.scheme){if(d(a.blacklist_regexp)||!0!==d(a.regexp))return"";n=this.get_product_id_from_dom(a.regexp_group)}else if(!n){if(d(a.blacklist_regexp))return"";
n=this.get_product_id_from_url(k,a.regexp,a.regexp_group)}h||!a.product_group_group||"string"===a.product_group_group&&a.product_group_group instanceof String||"html"!==a.product_group_group.scheme?h||a.product_group_regexp&&(h=this.get_product_id_from_url(k,a.product_group_regexp,a.product_group_group)):h=this.get_product_id_from_dom(a.product_group_group);if(n)a={product_id:n,product_group:h,product_action:p,product_category:q};else if(this.facebook_dummy_product_enabled()&&"facebook"===b)a=this.get_dummy_product_for_facebook(h);
else return null;c&&c(a);return a};
m.prototype.get_pid=function(a){this.extract_pid(a,"adroll",function(a){if(a){var c=a.product_id,d=a.product_group,h=a.product_action,n=a.product_category;a=[];var p;if(c instanceof Array)for(p=0;p<c.length;p++)a.push(["adroll_product_id",this.normalize_var((c[p]+"").toLowerCase(),!0)]);else a.push(["adroll_product_id",this.normalize_var((c+"").toLowerCase(),!0)]);if(n instanceof Array)for(p=0;p<n.length;p++)a.push(["adroll_product_category_id",this.normalize_var((n[p]+"").toLowerCase(),!0)]);else n&&
a.push(["adroll_product_category_id",this.normalize_var((n+"").toLowerCase(),!0)]);d&&a.push(["adroll_product_group",this.normalize_var((d+"").toLowerCase(),!0)]);h&&a.push(["adroll_product_action",this.normalize_var((h+"").toLowerCase(),!0)]);(c=this.external_data_to_qs(!0))&&a.push([c]);c=this._srv(this.buildurl("/p/"+this._global("adroll_adv_id")+"/",a));d=window.document.createElement("img");d.src=c;d.height=d.width=1;d.border=0;this._head().appendChild(d)}}.bind(this))};
m.prototype.get_product_id_from_dom=function(a){var b=null,c;a.path&&(window.jQuery?(c=window.jQuery(a.path),c.length&&(c=c.eq(0),b="text"===a.attribute?c.text():c.attr(a.attribute))):window.Prototype&&window.$$?(c=window.$$(a.path),c.length&&(c=c[0],b="text"===a.attribute?c.innerText&&!window.opera?c.innerText:c.innerHTML.stripScripts().unescapeHTML().replace(/[\n\r\s]+/g," "):c.readAttribute(a.attribute))):window.YUI?(c=window.YUI().use("node"),c.one&&(c=c.one(a.path),b=null,c&&(b="text"===a.attribute?
c.get("text"):c.getAttribute(a.attribute)))):window.$$&&(c=window.$$(a.path),c.length&&(c=c[0],b="text"===a.attribute?c.get("text"):c.getProperty(a.attribute))));if(b&&(b=b.replace(/^\s\s*/,"").replace(/\s\s*$/,""),a.regular_expression&&a.regular_expression_replace))if(c=new RegExp(a.regular_expression,"gi"),b=c.exec(b),null!==b){a=a.regular_expression_replace;for(c=0;c<b.length;c++)a=a.replace(new RegExp("\\\\"+c,"gi"),b[c]||"");b=a}else b="";return b};
m.prototype.get_product_id_from_url=function(a,b,c){var d=null;try{d=parseInt(c)}catch(h){}return null!==d&&!isNaN(d)&&b&&(a=(new RegExp(b,"gi")).exec(a),null!==a&&d in a)?a[d]:null};m.prototype.render_pixel_code=function(a,b){this.expire_old();var c=this._srv("/pixel"),d=window.document.createElement("script");d.setAttribute("async","true");d.type="text/javascript";var h=this.get_keywords();this.addLoadEvent(function(n){return function(){var p=[];try{p.push("adroll_s_ref="+window.escape(window.document.referrer))}catch(g){}try{p.push("keyw="+window.escape(h))}catch(g){}try{n._has_global("adroll_segments")&&p.push("name="+window.escape(n._global("adroll_segments").toLowerCase()))}catch(g){}try{var q=
n.get_conversion_value();q.conv_value&&p.push("conv_value="+q.conv_value);q.currency&&p.push("adroll_currency="+q.currency)}catch(g){}try{if(n._has_email()){var k=n._global("adroll_email"),k=k.replace(/^\s+|\s+$/g,""),f=k.toLowerCase();n.is_already_hashed(f)?p.push("hashed_email="+f):n.is_email_valid(k)?p.push("hashed_email="+n.md5(f)):(p.push("data_error=email"),p.push("data_error_message=invalid_format"))}}catch(g){}try{if(n._has_user_identifier()){var e=n._global("adroll_user_identifier"),e=e.replace(/^\s\s*/,
"").replace(/\s\s*$/,"");p.push("user_identifier="+n.md5(e))}}catch(g){}try{var l=n.external_data_to_qs(!0);l&&p.push(l)}catch(g){}p=n.get_base_url(c,a,b,null,"",p);d.src=p;n._head().appendChild(d)}}(this));this.addLoadEvent(function(a){return function(){var b=a._global("adroll");if(b&&"object"===typeof b){b.identify=function(){return a.identify.apply(a,arguments)};b.track=function(){return a.track.apply(a,arguments)};for(var c,d,f=0;f<b.length;f++)c=b[f][0],d=b[f][1],"identify"===c?a.identify.apply(a,
d):"track"===c&&a.track.apply(a,d)}}}(this))};
m.prototype.render_ad_code=function(a,b,c,d){d=this._is_defined(d)?d:null;if(!this._is_defined(this._r[b])||d){var h=["width="+this._global("adroll_width"),"height="+this._global("adroll_height"),"x=0","y=0"];if(c)this.log("Rendering test ad "+c+" in space "+b),h.push("test_ad="+c),a=this.get_url(a,b,null,"ad",h);else if(d){this.log("Rendering adgroup "+d);c=this.macro_values();var n=this.macro_url_params(c,!1,!1,!1,!1);h.push(n);this.render_win_notification(c);a=this.get_url(a,b,d,null,h)}else this.log("Rendering ad space "+
b),a=this.get_url(a,b,null,"ad",h);this.expire_old();window.document.write('<script src="'+a+'">\x3c/script>');this._nad+=1;this._r[b]=1}};m.prototype.render_win_notification=function(a){if(a.adroll_cpm_macro&&a.adroll_win_notif){var b=(this._secure()?"https://":"http://")+a.adroll_win_notif+a.adroll_cpm_macro;a.adroll_ad_payload&&a.adroll_rtb_dict&&a.adroll_rtb_dict.waap&&(b+="&ad_payload="+a.adroll_ad_payload);this.imgRequest(b)}};
m.prototype.get_base_url=function(a,b,c,d,h,n){a=a+"/"+b+"/"+c+(d?"/"+d:"")+(h?"/"+h:"");var p="";this.cookieEnabled(!1)?(p=window.escape(this.get_eids()),a+="?pv="+this.pv+"&cookie="+p):a+="?no-cookies=1&pv="+this.pv;n&&(a+="&"+n.join("&"));if(a.length>this._url){this.del(this.__adc);if(a.length-p.length>this._url)return"#";this.log("Url was too big, shrinking it");return this.get_url(b,c,d,h,n)}this.log("Generated url: "+a);return a};
m.prototype.get_url=function(a,b,c,d,h){var n=c?this._srv("/c"):this._srv("/r");return this.get_base_url(n,a,b,c,d,h)};m.prototype.get_eids=function(){if(this._global("adroll_ext_network")||this._global("adroll_optout"))return"";try{for(var a=this.get(this.__adc),b=a?a.split("|"):"",a=[],c=b.length-1;0<=c;c--)if(b[c]){var d=b[c].split(":");a.push([d[0],d[2]].join(":"))}return a.join("|")}catch(h){return this.del(this.__adc),""}};m.prototype.record_user=function(a){var b="adroll_conversion_value adroll_conversion_value_in_dollars adroll_segments adroll_email adroll_user_identifier adroll_currency".split(" "),c,d;a=a||{};var h={adroll_email:!0,adroll_user_identifier:!0};for(c=0;c<b.length;c++){try{this._unset_global(b[c])}catch(n){}if(b[c]in a){b[c]in h?this._set_global(b[c],window.escape(a[b[c]])):this._set_global(b[c],a[b[c]]);try{delete a[b[c]]}catch(n){}}}try{this._unset_global("adroll_custom_data")}catch(n){}for(d in a)if(a.hasOwnProperty(d)){this._set_global("adroll_custom_data",
a);break}this.render_pixel_code(this._global("adroll_adv_id"),this._global("adroll_pix_id"))};m.prototype.record_adroll_email=function(a){if(this._has_email()){var b=this._global("adroll_email"),b=b.replace(/^\s+|\s+$/g,""),c,d=b.toLowerCase();this.is_already_hashed(d)?c=d:this.is_email_valid(b)&&(c=this.md5(d));b="https://d.adroll.com/id/"+this._global("adroll_adv_id")+"/?hashed_email="+c;a&&(b+="&idsource="+a);this.imgRequest(b)}};
m.prototype._send_plain_text_identifiers=function(a,b,c){(a||b)&&c&&(c="https://d.adroll.com/id/"+this._global("adroll_adv_id")+"/?idsource="+c,a&&(a=a.replace(/^\s+|\s+$/g,"").toLowerCase(),c+="&email="+window.encodeURIComponent(a)+"&hashed_email="+this.md5(a)),b&&(c+="&user_identifier="+window.encodeURIComponent(b)),this.imgRequest(c))};m.prototype._has_email=function(){return this._has_global("adroll_email")&&"username@example.com"!==this._global("adroll_email")};
m.prototype._has_user_identifier=function(){return this._has_global("adroll_user_identifier")&&"example_user_id"!==this._global("adroll_user_identifier")};m.prototype.is_already_hashed=function(a){return/^[a-f0-9]{32}$/.test(a)};m.prototype.is_email_valid=function(a){return/[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?/.test(a)};
m.prototype.identify=function(a,b){(a.email||a.userId)&&this._send_plain_text_identifiers(a.email,a.userId,b||"adroll-identify");a.email&&this._set_global("adroll_email",a.email);var c=this.copyObj(a,["email","userId"]);c&&(c="https://d.adroll.com/uat/"+this._global("adroll_adv_id")+"/"+this._global("adroll_pix_id")+"/?user_attributes="+window.encodeURIComponent(this.jsonStringify(c)),b&&(c+="&idsource="+b),this.imgRequest(c));this._queueAndCallback("identify",[a,b])};
m.prototype.track=function(a,b){if(a){var c="https://d.adroll.com/uev/"+this._global("adroll_adv_id")+"/"+this._global("adroll_pix_id")+"/?event_name="+window.encodeURIComponent(a),d=this.copyObj(b);d&&(c+="&event_attributes="+window.encodeURIComponent(this.jsonStringify(d)));this.imgRequest(c);this._queueAndCallback("track",[a,b])}};
m.prototype._registerCallback=function(a,b,c){this.callbacks=this.callbacks||{};this.callbackNames=this.callbackNames||[];this.callbacks[a]=this.callbacks[a]||[];if(!("function"!==typeof b||-1<this.callbackNames.indexOf(c))&&(this.callbackNames.push(c),this.callbacks[a].push(b),this.callbackQueues&&this.callbackQueues[a]&&this.callbackQueues[a].length))for(c=0;c<this.callbackQueues[a].length;c++)b.apply(null,this.callbackQueues[a][c])};
m.prototype._queueAndCallback=function(a,b){this.callbackQueues=this.callbackQueues||{};this.callbackQueues[a]=this.callbackQueues[a]||[];this.callbackQueues[a].push(b);if(this.callbacks&&this.callbacks[a]&&this.callbacks[a].length)for(var c=0;c<this.callbacks[a].length;c++)this.callbacks[a][c].apply(null,b)};m.prototype.registerIdentifyCallback=function(a,b){this._registerCallback("identify",a,b)};m.prototype.registerTrackCallback=function(a,b){this._registerCallback("track",a,b)};m.prototype._is_defined=function(a){return"undefined"!==typeof a};m.prototype.normalize_var=function(a,b){if(!a)return"";a=a.toString().substr(0,this._kwl).replace(/,/gi,".");b&&(a=window.escape(a));return a};m.prototype.get_keywords=function(){try{var a=window.document.referrer||"";if(!a)return"";var b=this.parseUri(a);return-1!==b.host.indexOf("www.google.")?b.queryKey.q.substring(0,this._kwl):-1!==b.host.indexOf("bing.com")?b.queryKey.q.substring(0,this._kwl):""}catch(c){return""}};
m.prototype.parseUri=function(a){a=/^(?:(?![^:@]+:[^:@\/]*@)([^:\/?#.]+):)?(?:\/\/)?((?:(([^:@]*):?([^:@]*))?@)?([^:\/?#]*)(?::(\d*))?)(((\/(?:[^?#](?![^?#\/]*\.[^?#\/.]+(?:[?#]|$)))*\/?)?([^?#\/]*))(?:\?([^#]*))?(?:#(.*))?)/.exec(a);for(var b={queryKey:{}},c=14,d="source protocol authority userInfo user password host port relative path directory file query anchor".split(" ");c--;)b[d[c]]=a[c]||"";b[d[12]].replace(/(?:^|&)([^&=]*)=?([^&]*)/g,function(a,c,d){c&&(b.queryKey[c]=d)});return b};
m.prototype._secure=function(){return!0};m.prototype._protocol=function(){return window.document.location.protocol};m.prototype._native=function(){try{return"http"!==this._protocol().slice(0,4)}catch(a){return!0}};m.prototype._srv=function(a){a=this._is_defined(a)?a:"";return"https://d.adroll.com"+a};m.prototype._cdn=function(a){a=this._is_defined(a)?a:"";return"https://s.adroll.com"+a};m.prototype.log=function(a){this._logs.push(a)};
m.prototype.read_log=function(a){return this._logs.join(a?"\n":"<br>\n")};m.prototype.normalize_url=function(a){return a.toLowerCase()};m.prototype.imgRequest=function(a){var b=new window.Image;b.src=a;b.setAttribute("width","1");b.setAttribute("height","1");b.setAttribute("border","0");this._head().appendChild(b)};m.prototype.copyObj=function(a,b){if(!a)return null;var c={},d=0,h;for(h in a)!a.hasOwnProperty(h)||b&&-1!==b.indexOf(h)||(d++,c[h]=a[h]);return d?c:null};window.__adroll=window.__adroll||new m;}());
(function(a){a.adroll_optout=!1;a.adroll_ext_network=null;a.adroll_callbacks="undefined"===typeof a.adroll_callbacks?[]:a.adroll_callbacks;a.__adroll.render_pixel_code(a.adroll_adv_id,a.adroll_pix_id)})(window);
