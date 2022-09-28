import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
(new Date).getTime()
'''

let imba-code = '''
(new Date).getTime()
'''
test 'parenthesized_new' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js