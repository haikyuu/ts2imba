import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
function fn () {
  a = 2;
  return;
}
'''

let imba-code = '''
fn = ->
  `a = 2`
  return
'''
test 'global_assignment_compat' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js