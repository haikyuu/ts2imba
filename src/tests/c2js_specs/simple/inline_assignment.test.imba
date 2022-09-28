import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
var a, m;
if (a = m = match) {
  m();
}
'''

let imba-code = '''
a = undefined
m = undefined
if a = m = match
  m()
'''
test 'inline_assignment' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js