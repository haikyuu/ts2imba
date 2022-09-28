import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
a("hello", 2);
'''

let imba-code = '''
a 'hello', 2
'''
test 'function_call_with_arguments' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js