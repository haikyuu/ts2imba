import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
function x() {
  if (true) {
    return 2;
  }

  var b = 3;
  return b;
}
'''

let imba-code = '''
x = ->
  return 2  if true
  b = 3
  b
'''
test 'return_in_if' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js