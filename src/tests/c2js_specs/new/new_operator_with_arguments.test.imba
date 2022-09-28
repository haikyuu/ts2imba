import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
var a = new B(x,y);
'''

let imba-code = '''
a = new B(x, y)
'''
test 'new_operator_with_arguments' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js