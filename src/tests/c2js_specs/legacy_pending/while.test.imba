import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
while (!a) { alert(1); }
'''

let imba-code = '''
alert 1  until a
'''
test 'while' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js