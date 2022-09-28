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
// four
// five
// six
function y() {
  return;
}
'''

let imba-code = '''
# one
# two
# three

x = ->
  return

# four
# five
# six

y = ->
  return

a()
'''
test 'multiple_functions_with_multiple_comments' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js