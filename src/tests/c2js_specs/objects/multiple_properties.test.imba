import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
a = { b: 2, c: 3 }
'''

let imba-code = '''
a =
  b: 2
  c: 3
'''
test 'multiple_properties' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js