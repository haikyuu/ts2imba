import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
a ? b : c ? d : e
'''

let imba-code = '''
if a then b else if c then d else e
'''
test 'ternary_operator_nesting' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js