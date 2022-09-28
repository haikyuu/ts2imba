import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
if (a) { b(); }
else { c(); }
'''

let imba-code = '''
if a
  b()
else
  c()
'''
test 'if_with_else' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js