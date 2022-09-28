import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
a ? (b=c) : d
'''

let imba-code = '''
if a then (b = c) else d
'''
test 'ternary_and_assignment' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js