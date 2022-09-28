import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
var a = new (require('foo'))(b)
'''

let imba-code = '''
a = new (require('foo'))(b)
'''
test 'new_with_complex_callee' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js