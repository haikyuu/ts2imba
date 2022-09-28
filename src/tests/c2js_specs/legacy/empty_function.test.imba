import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
(function($) {})()
'''

let imba-code = '''
(($) ->
)()
'''
test 'empty_function' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js