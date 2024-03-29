import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
!function(e) {
    if ("object" == typeof exports && "undefined" != typeof module) module.exports = e(); else if ("function" == typeof define && define.amd) define([], e); else {
        var f;
        "undefined" != typeof window ? f = window : "undefined" != typeof global ? f = global : "undefined" != typeof self && (f = self), 
        f.aoeu = e();
    }
}(function() {
    var define, module, exports;
    return function e(t, n, r) {
        function s(o, u) {
            if (!n[o]) {
                if (!t[o]) {
                    var a = typeof require == "function" && require;
                    if (!u && a) return a(o, !0);
                    if (i) return i(o, !0);
                    var f = new Error("Cannot find module '" + o + "'");
                    throw f.code = "MODULE_NOT_FOUND", f;
                }
                var l = n[o] = {
                    exports: {}
                };
                t[o][0].call(l.exports, function(e) {
                    var n = t[o][1][e];
                    return s(n ? n : e);
                }, l, l.exports, e, t, n, r);
            }
            return n[o].exports;
        }
        var i = typeof require == "function" && require;
        for (var o = 0; o < r.length; o++) s(r[o]);
        return s;
    }({
        1: [ function(require, module, exports) {
            module.exports = "hello";
        }, {} ]
    }, {}, [ 1 ])(1);
});

console.log(module.exports);
'''

let imba-code = '''
!((e) ->
  if 'object' == typeof exports and 'undefined' != typeof module
    module.exports = e()
  else if 'function' == typeof define and define.amd
    define [], e
  else
    f = undefined
    if 'undefined' != typeof window then (f = window) else if 'undefined' != typeof global then (f = global) else 'undefined' != typeof self and (f = self)
    f.aoeu = e()
  return
)(->
  define = undefined
  module = undefined
  exports = undefined
  ((t, n, r) ->
    i = typeof require == 'function' and require

    s = (o, u) ->
      if !n[o]
        if !t[o]
          a = typeof require == 'function' and require
          if !u and a
            return a(o, !0)
          if i
            return i(o, !0)
          f = new Error('Cannot find module \'' + o + '\'')
          throw f.code = 'MODULE_NOT_FOUND'
          f

        l = n[o] = exports: {}
        t[o][0].call l.exports, ((e) ->
          `var n`
          n = t[o][1][e]
          s if n then n else e
        ), l, l.exports, e, t, n, r
      n[o].exports

    o = 0
    while o < r.length
      s r[o]
      o++
    s
  )({ 1: [
    (require, module, exports) ->
      module.exports = 'hello'
      return
    {}
  ] }, {}, [ 1 ]) 1
)
console.log module.exports
'''
test 'browserify_standalone_wrapper' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js