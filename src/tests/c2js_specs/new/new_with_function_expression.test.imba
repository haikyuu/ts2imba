import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
var a = new MyClass('left', function () {
  go();
  return;
})
'''

let imba-code = '''
a = new MyClass('left', ->
  go()
  return
)
'''
test 'new_with_function_expression' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js