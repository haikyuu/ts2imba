import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
function fn () {
  return;
}
'''

let imba-code = '''
fn = ->
  return
'''
test 'return_nothing' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js