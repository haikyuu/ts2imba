import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
function fn(x) {
  x = 2;
  return
}
'''

let imba-code = '''
fn = (x) ->
  x = 2
  return
'''
test 'in_function_params' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js