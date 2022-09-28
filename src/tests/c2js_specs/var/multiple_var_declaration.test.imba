import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
var a = 1, b = 2
'''

let imba-code = '''
a = 1
b = 2
'''
test 'multiple_var_declaration' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js