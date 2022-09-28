import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
void 0
'''

let imba-code = '''
undefined
'''
test 'void_0' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js