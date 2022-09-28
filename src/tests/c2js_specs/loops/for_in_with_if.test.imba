import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
if (condition) {
  for (var a in b) if (c) d();
}
'''

let imba-code = '''
if condition
  for a of b
    if c
      d()
'''
test 'for_in_with_if' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js