import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
new (X())
'''

let imba-code = '''
new (X())
'''
test 'parenthesized_classname_in_new' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js