import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
if (x) { 2 }
'''

let imba-code = '''
2  if x
'''
test 'single_line_if' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js