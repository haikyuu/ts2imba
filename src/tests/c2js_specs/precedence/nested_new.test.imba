import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
new X(new Y)
'''

let imba-code = '''
new X(new Y)
'''
test 'nested_new' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js