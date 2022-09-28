import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
a(/=\s/)
'''

let imba-code = '''
a RegExp('=\\s')
'''
test 'equals' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js