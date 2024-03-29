import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
a << b;
a >> b;
a | b;
a ^ b;
a & b;
a ^ b & c | d;
'''

let imba-code = '''
a << b
a >> b
a | b
a ^ b
a & b
a ^ b & c | d
'''
test 'binary_operators' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js