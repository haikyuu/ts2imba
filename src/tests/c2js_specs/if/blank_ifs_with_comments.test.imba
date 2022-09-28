import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
if (condition) {
  // pass
}
'''

let imba-code = '''
if condition
  # pass
else
'''
test 'blank_ifs_with_comments' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js