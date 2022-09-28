import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
x = 2


y = 3
'''

let imba-code = '''
x = 2
y = 3
'''
test 'blank_lines' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js