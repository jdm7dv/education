(function(){var f=this,h=function(a,b,c){return a.call.apply(a.bind,arguments)},k=function(a,b,c){if(!a)throw Error();if(2<arguments.length){var d=Array.prototype.slice.call(arguments,2);return function(){var c=Array.prototype.slice.call(arguments);Array.prototype.unshift.apply(c,d);return a.apply(b,c)}}return function(){return a.apply(b,arguments)}},l=function(a,b,c){Function.prototype.bind&&-1!=Function.prototype.bind.toString().indexOf("native code")?l=h:l=k;return l.apply(null,arguments)},m=Date.now||function(){return+new Date};var n=Array.prototype.forEach?function(a,b,c){Array.prototype.forEach.call(a,b,c)}:function(a,b,c){for(var d=a.length,g="string"==typeof a?a.split(""):a,e=0;e<d;e++)e in g&&b.call(c,g[e],e,a)};var p=function(a){p[" "](a);return a};p[" "]=function(){};var q=document,r=window;var v=function(){var a=t;try{var b;if(b=!!a&&null!=a.location.href)a:{try{p(a.foo);b=!0;break a}catch(c){}b=!1}return b}catch(c){return!1}};var w=function(){var a=!1;try{var b=Object.defineProperty({},"passive",{get:function(){a=!0}});f.addEventListener("test",null,b)}catch(c){}return a}(),x=function(a,b,c){a.addEventListener?a.addEventListener(b,c,w?void 0:!1):a.attachEvent&&a.attachEvent("on"+b,c)};var y=!!window.google_async_iframe_id,t=y&&window.parent||window;var z=/^(?:([^:/?#.]+):)?(?:\/\/(?:([^/?#]*)@)?([^/#?]*?)(?::([0-9]+))?(?=[/#?]|$))?([^?#]+)?(?:\?([^#]*))?(?:#([\s\S]*))?$/,A=function(a){return a?decodeURI(a):a};var B=function(a,b){var c=(c=f.performance)&&c.now?c.now():m();this.label=a;this.type=b;this.value=c;this.duration=0;this.uniqueId=this.label+"_"+this.type+"_"+Math.random()};var C=function(a,b){this.i=[];this.h=b||f;var c=null;b&&(b.google_js_reporting_queue=b.google_js_reporting_queue||[],this.i=b.google_js_reporting_queue,c=b.google_measure_js_timing);a:{try{var d=(this.h||f).top.location.hash;if(d){var g=d.match(/\bdeid=([\d,]+)/);var e=g&&g[1]||"";break a}}catch(u){}e=""}b=e;b=b.indexOf&&0<=b.indexOf("1337");this.g=(this.g=null!=c?c:Math.random()<a)||b;a=this.h.performance;this.j=!!(a&&a.mark&&a.clearMarks&&b)};C.prototype.l=function(a){if(a&&this.j){var b=this.h.performance;b.clearMarks("goog_"+a.uniqueId+"_start");b.clearMarks("goog_"+a.uniqueId+"_end")}};C.prototype.start=function(a,b){if(!this.g)return null;a=new B(a,b);this.j&&this.h.performance.mark("goog_"+a.uniqueId+"_start");return a};if(y&&!v()){var D="."+q.domain;try{for(;2<D.split(".").length&&!v();)q.domain=D=D.substr(D.indexOf(".")+1),t=window.parent}catch(a){}v()||(t=window)}var F=t,G=new C(1,F),H=function(){F.google_measure_js_timing||(G.i!=G.h.google_js_reporting_queue&&(G.i.length=0,G.j&&n(G.i,G.l,G)),G.g=!1)};"complete"==F.document.readyState?H():G.g&&x(F,"load",function(){H()});var L=function(a,b,c,d,g,e,u,E,S){I(q.hidden)?(this.h="hidden",this.j="visibilitychange"):I(q.mozHidden)?(this.h="mozHidden",this.j="mozvisibilitychange"):I(q.msHidden)?(this.h="msHidden",this.j="msvisibilitychange"):I(q.webkitHidden)&&(this.h="webkitHidden",this.j="webkitvisibilitychange");this.o=!1;this.g=a;this.i=-1;this.s=b;this.u=c;this.I=d;this.F=e;this.A=u?"mousedown":"click";g&&q[this.h]&&J(this,2);this.G=E;this.D=S||0;this.v=this.B=this.l=this.w=null;a=l(this.H,this);x(q,this.j,a);K(this)};L.prototype.H=function(){if(q[this.h])this.o&&(this.C(),this.i=m(),J(this,0));else{if(-1!=this.i){var a=m()-this.i;a>this.D&&(this.i=-1,J(this,1,a),null!==this.g&&(this.g.registerFinalizeCallback(l(this.g.fireOnObject,this.g,"attempt_survey_trigger",["wfocus",this.u,this.s,this.l,this.B,this.v,a])),5E3<a&&this.g.fireOnObject("should_show_thank_you",{})))}this.F&&J(this,3)}};var K=function(a){if(null!==a.g){var b=l(function(a,b,c){a=b.J();this.l=a.N().O();this.l||(b=a.M(),this.l=""+A(b.match(z)[3]||null)+A(b.match(z)[5]||null));this.B=a.L();this.v=a.K();this.m(c)},a),c=a.A;a.g.forEachAd(function(a){a.forEachNavigationAdPiece(function(d){a.listen(d,c,b)})})}else{var d=l(a.m,a);x(r,a.A,d)}};L.prototype.m=function(a){this.w=a.button;this.o=!0;a=l(this.C,this);r.setTimeout(a,5E3)};L.prototype.handleClick=L.prototype.m;L.prototype.C=function(){this.o=!1};var J=function(a,b,c){var d=["//",a.I?"googleads.g.doubleclick.net":"pagead2.googlesyndication.com","/pagead/gen_204?id=wfocus","&gqid="+a.s,"&qqid="+a.u].join("");0==b&&(d+="&return=0");1==b&&(d+="&return=1&timeDelta="+c,a.G&&(d+="&cbtn="+a.w));2==b&&(d+="&bgload=1");3==b&&(d+="&fg=1");r.google_image_requests||(r.google_image_requests=[]);a=r.document.createElement("img");a.src=d;r.google_image_requests.push(a)},I=function(a){return"undefined"!==typeof a};var M=function(a,b,c,d,g,e,u,E){return new L(null,a,b,c,d,g,e,u,E)},N=["wfocusnhinit"],O=f;N[0]in O||!O.execScript||O.execScript("var "+N[0]);for(var P;N.length&&(P=N.shift());){var Q;if(Q=!N.length)Q=void 0!==M;Q?O[P]=M:O[P]&&O[P]!==Object.prototype[P]?O=O[P]:O=O[P]={}}var R=r.google_wf_async,T;if(T=R&&R.call)T="function"===typeof R;T&&r.google_wf_async();}).call(this);
