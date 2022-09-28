import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
if (w) {
  x(y(function() {
    return true
  }));
  z()
}
'''

let imba-code = '''
if w
  x y(->
    true
  )
  z()
'''
test 'indentation_of_parentheses' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js