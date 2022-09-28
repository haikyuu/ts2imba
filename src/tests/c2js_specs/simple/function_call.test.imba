import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
alert("Hello world");
'''

let imba-code = '''
alert 'Hello world'
'''
test 'function_call' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js