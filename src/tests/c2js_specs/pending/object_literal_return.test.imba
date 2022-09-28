import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
function x() {
  return { a: 1, b: 2 };
}
'''

let imba-code = '''
x = ->
  a: 1
  b: 2
'''
test 'object_literal_return' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js