import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
a(function() {
  b();
  return;
});
'''

let imba-code = '''
a ->
  b()
  return
'''
test 'call_with_function' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js