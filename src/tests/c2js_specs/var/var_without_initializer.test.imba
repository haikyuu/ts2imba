import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
var a;
'''

let imba-code = '''
a = undefined
'''
test 'var_without_initializer' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js