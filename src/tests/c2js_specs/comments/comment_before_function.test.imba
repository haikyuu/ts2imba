import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
a()
/*
 * comment
 */
function x() {
  return;
}
'''

let imba-code = '''
###
# comment
###

x = ->
  return

a()
'''
test 'comment_before_function' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js