import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
a({ one: 1 }, { two: 2 })
'''

let imba-code = '''
a { one: 1 }, two: 2
'''
test 'call_with_multiple_objects' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js