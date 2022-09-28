import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
Math.pow(2, 8)
'''

let imba-code = '''
2 ** 8
'''
test 'exponents' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js