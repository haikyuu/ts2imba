import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
if (x) {
  a,b,c;
}
'''

let imba-code = '''
if x
  a
  b
  c
'''
test 'sequence_expression_with_indent' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js