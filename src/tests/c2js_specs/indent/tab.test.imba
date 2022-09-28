import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
if (condition) {
  consequent();
}
'''

let imba-code = '''
if condition
	consequent()
'''
test 'tab' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js