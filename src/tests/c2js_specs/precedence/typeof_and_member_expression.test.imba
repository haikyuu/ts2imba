import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
(typeof x)[2]
'''

let imba-code = '''
(typeof x)[2]
'''
test 'typeof_and_member_expression' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js