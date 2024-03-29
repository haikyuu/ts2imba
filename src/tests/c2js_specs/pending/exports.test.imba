import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
if (typeof exports !== 'undefined') {
  exports = module.exports = {};
}
'''

let imba-code = '''
if typeof exports != 'undefined'
  `exports = module.exports = {}`
'''
test 'exports' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js