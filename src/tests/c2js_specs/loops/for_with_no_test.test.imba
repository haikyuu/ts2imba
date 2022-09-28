import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
for (a;;c) {
  d();
}
'''

let imba-code = '''
a
loop
  d()
  c
'''
test 'for_with_no_test' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js