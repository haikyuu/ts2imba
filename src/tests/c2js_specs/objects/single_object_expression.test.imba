import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
({ a: 1, b: 2 })
'''

let imba-code = '''
a: 1
b: 2
'''
test 'single_object_expression' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js