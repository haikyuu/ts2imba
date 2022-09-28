import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
for (a;b;) {
  d();
}
'''

let imba-code = '''
a
while b
  d()
'''
test 'for_with_no_update' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js