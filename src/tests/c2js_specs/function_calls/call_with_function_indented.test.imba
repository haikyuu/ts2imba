import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
if (x) {
  setTimeout(function() { return go(); }, 300)
}
'''

let imba-code = '''
if x
  setTimeout (->
    go()
  ), 300
'''
test 'call_with_function_indented' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js