import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
Math.pow(1 * 2, 8)
Math.pow(!x, 8)
Math.pow(x++, 8)
Math.pow(++y, 8)
Math.pow(new X, 8)
Math.pow(new X(2), 8)
Math.pow(a < b, 8)
'''

let imba-code = '''
(1 * 2) ** 8
(!x) ** 8
x++ ** 8
++y ** 8
new X ** 8
new X(2) ** 8
(a < b) ** 8
'''
test 'exponents_precedence' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js