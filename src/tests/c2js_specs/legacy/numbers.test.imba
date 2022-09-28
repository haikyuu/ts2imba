import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
var x = 1e3;
'''

let imba-code = '''
x = 1e3
'''
test 'numbers' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js