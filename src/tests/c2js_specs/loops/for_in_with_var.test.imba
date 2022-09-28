import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
for (var x in y) {
  z();
}
'''

let imba-code = '''
for x of y
  z()
'''
test 'for_in_with_var' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js