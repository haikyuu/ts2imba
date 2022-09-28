import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
function bar() {
    if (1) return 1;
}
function foo() {
    if (1) { return 1; }
}
function baz() {
    if (1) return 2; else return 1;
}
'''

let imba-code = '''
bar = ->
  1  if 1
foo = ->
  1  if 1
baz = ->
  if 1
    2
  else
    1
'''
test 'if_return' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js