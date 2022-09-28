import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
while (a) {}
'''

let imba-code = '''
while a
  continue
'''
test 'empty_while' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js