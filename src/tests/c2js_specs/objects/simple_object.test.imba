import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
var a = { b: 2 }
'''

let imba-code = '''
a = b: 2
'''
test 'simple_object' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js