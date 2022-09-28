import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
function x() {}
'''

let imba-code = '''
x = ->
'''
test 'function_with_keyword' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js