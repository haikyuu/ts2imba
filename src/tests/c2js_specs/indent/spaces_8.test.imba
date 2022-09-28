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
test 'spaces_8' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js