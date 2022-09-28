import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
a ? b : c ? d : e
'''

let imba-code = '''
if a then b else if c then d else e
'''
test 'nested_ternary' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js