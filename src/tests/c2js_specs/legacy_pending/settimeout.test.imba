import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
setTimeout(function() { return foo() }, 500);
alert(setTimeout(function() { return foo() }, 500));
call(function() { return foo() });
'''

let imba-code = '''
setTimeout (->
  foo()
), 500
alert setTimeout(->
  foo()
, 500)
call ->
  foo()
'''
test 'settimeout' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js