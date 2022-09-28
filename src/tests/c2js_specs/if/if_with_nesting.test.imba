import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
if (a) {
  if (b) {
    c();
  }
}
'''

let imba-code = '''
if a
  if b
    c()
'''
test 'if_with_nesting' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js