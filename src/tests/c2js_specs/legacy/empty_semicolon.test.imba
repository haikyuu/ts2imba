import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
2;;;3
'''

let imba-code = '''
2
3
'''
test 'empty_semicolon' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js