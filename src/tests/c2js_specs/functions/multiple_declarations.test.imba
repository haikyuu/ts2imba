import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
function one() {
  return a();
}
function two() {
  return b();
}
'''

let imba-code = '''
one = ->
  a()

two = ->
  b()
'''
test 'multiple_declarations' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js