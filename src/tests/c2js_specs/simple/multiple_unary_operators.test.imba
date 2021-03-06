import {test, expect} from "vitest"
import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
0 + - + - - 1
'''

let imba-code = '''
0 + - + - -1
'''
test 'multiple_unary_operators' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js