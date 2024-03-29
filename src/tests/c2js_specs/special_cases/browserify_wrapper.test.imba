import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
(function e(t, n, r) {
    function s(o, u) {
        if (!n[o]) {
            if (!t[o]) {
                var a = typeof require == "function" && require;
                if (!u && a) return a(o, !0);
                if (i) return i(o, !0);
                throw new Error("Cannot find module '" + o + "'");
            }
            var f = n[o] = {
                exports: {}
            };
            t[o][0].call(f.exports, function(e) {
                var n = t[o][1][e];
                return s(n ? n : e);
            }, f, f.exports, e, t, n, r);
        }
        return n[o].exports;
    }
    var i = typeof require == "function" && require;
    for (var o = 0; o < r.length; o++) s(r[o]);
    return s;
})({
    1: [ function(require, module, exports) {
        console.log("hello");
    }, {} ]
}, {}, [ 1 ]);
'''

let imba-code = '''
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
        throw new Error('Cannot find module \'' + o + '\'')
      f = n[o] = exports: {}
      t[o][0].call f.exports, ((e) ->
        `var n`
        n = t[o][1][e]
        s if n then n else e
      ), f, f.exports, e, t, n, r
    n[o].exports

  o = 0
  while o < r.length
    s r[o]
    o++
  s
) { 1: [
  (require, module, exports) ->
    console.log 'hello'
    return
  {}
] }, {}, [ 1 ]
'''
test 'browserify_wrapper' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js