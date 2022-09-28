import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
if (true) {
  var a = 1, b = 2;
}
'''

let imba-code = '''
if true
  a = 1
  b = 2
'''
test 'multiple_var_declarations_with_indent' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js