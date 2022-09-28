import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
(function() {
  return this.foo;
})
'''

let imba-code = '''
->
  @foo
'''
test 'this_attribute' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js