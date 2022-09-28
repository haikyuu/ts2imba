import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
if (a) {
  b();
  c();
  d();
}
'''

let imba-code = '''
if a
  b()
  c()
  d()
'''
test 'if_blocks' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js