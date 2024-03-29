import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
var a = 1
'''

let imba-code = '''
a = 1
'''
test 'var_declaration' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js