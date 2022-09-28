import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
"\n"
'''

let imba-code = '''
'\n'
'''
test 'string_with_escapes' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js