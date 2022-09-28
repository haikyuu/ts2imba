import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
function fn() {
  if (x)
    return { a: 1, b: 2 };
  return true;
}
'''

let imba-code = '''
fn = ->
  if x
    return {
      a: 1
      b: 2
    }
  true
'''
test 'return_object' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js