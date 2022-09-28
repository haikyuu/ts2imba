import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
var a = new B
'''

let imba-code = '''
a = new B
'''
test 'new_operator' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js