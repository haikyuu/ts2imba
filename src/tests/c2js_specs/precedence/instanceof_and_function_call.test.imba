import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
(a instanceof b)(c)
'''

let imba-code = '''
(a instanceof b) c
'''
test 'instanceof_and_function_call' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js