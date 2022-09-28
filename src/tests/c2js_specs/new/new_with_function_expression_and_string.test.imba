import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
var a = new MyClass(function () {
  go();
  return;
}, 'left')
'''

let imba-code = '''
a = new MyClass((->
  go()
  return
), 'left')
'''
test 'new_with_function_expression_and_string' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js