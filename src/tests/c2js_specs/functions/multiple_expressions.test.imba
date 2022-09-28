import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
obj.one = function () {
  return a();
};
obj.two = function () {
  return b();
};
'''

let imba-code = '''
obj.one = ->
  a()

obj.two = ->
  b()
'''
test 'multiple_expressions' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js