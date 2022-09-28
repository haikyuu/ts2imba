import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
var a = Math.pow(2)
'''

let imba-code = '''
a = Math.pow(2)
'''
test 'exponents_with_strange_arguments' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js