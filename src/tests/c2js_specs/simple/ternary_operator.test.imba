import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
a ? b : c
'''

let imba-code = '''
if a then b else c
'''
test 'ternary_operator' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js