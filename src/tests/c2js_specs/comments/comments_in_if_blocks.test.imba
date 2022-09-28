import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
if (true) {
  // yes
} else {
  // no
}
'''

let imba-code = '''
if true
  # yes
else
  # no
'''
test 'comments_in_if_blocks' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js