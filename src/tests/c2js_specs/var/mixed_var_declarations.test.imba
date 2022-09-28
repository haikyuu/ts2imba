import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
if (true) {
  var a = 1, b, c = 2, d;
}
'''

let imba-code = '''
if true
  a = 1
  b = undefined
  c = 2
  d = undefined
'''
test 'mixed_var_declarations' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js