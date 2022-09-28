import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
while (condition) { a(); }
'''

let imba-code = '''
while condition
  a()
'''
test 'while' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js