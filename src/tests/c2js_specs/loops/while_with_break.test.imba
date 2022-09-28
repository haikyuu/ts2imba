import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
while (condition) {
  if (x) break;
  a();
}
'''

let imba-code = '''
while condition
  if x
    break
  a()
'''
test 'while_with_break' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js