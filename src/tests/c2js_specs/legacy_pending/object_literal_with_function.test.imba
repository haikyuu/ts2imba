import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
x = function() { }
({a:2,b:3});
'''

let imba-code = '''
x = ->
(
  a: 2
  b: 3
)
'''
test 'object_literal_with_function' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js