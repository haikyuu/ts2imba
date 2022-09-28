import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
function h () {
  h = 2;
}
'''

let imba-code = '''
h = ->
  `var h`
  h = 2
'''
test 'shadowing_of_function_names' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js