import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
+{ a: '2' }
'''

let imba-code = '''
+{ a: '2' }
'''
test 'unary_and_object_expression' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js