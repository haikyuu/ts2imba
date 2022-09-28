import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
if (typeof a === 'string') { a = 2; }
'''

let imba-code = '''
if typeof a == 'string'
  `a = 2`
'''
test 'global' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js