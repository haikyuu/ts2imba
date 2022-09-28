import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
var x = function fn() {
  return fn;
}
'''

let imba-code = '''
x = ->
  fn
'''
test 'named_function_expressions' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js