import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
for (;;) {
  d();
}
'''

let imba-code = '''
loop
  d()
'''
test 'for_with_no_arguments' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js