import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
a()
// one
// two
// three
function x() {
  return;
}
'''

let imba-code = '''
# one
# two
# three

x = ->
  return

a()
'''
test 'line_comments_before_function' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js