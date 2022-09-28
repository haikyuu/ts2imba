import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
if ((x !== 2) && (2)) { 2;2 } else true
'''

let imba-code = '''
if x != 2 and 2
  2
  2
else
  true
'''
test 'single_line_else' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js