import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
var a = 2 || {}
'''

let imba-code = '''
a = 2 or {}
'''
test 'or' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js