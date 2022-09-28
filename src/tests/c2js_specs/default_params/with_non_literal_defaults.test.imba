import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
function fn(param = (a + b())) {
  return true
}
'''

let imba-code = '''
fn = (param = a + b()) ->
  true
'''
test 'with_non_literal_defaults' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js