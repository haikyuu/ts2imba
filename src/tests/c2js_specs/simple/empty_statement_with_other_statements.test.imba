import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
a();;;b()
'''

let imba-code = '''
a()
b()
'''
test 'empty_statement_with_other_statements' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js