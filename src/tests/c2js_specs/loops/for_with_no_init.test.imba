import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
for (;b;c) {
  d();
}
'''

let imba-code = '''
while b
  d()
  c
'''
test 'for_with_no_init' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js