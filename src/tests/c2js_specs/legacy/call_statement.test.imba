import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
function x() {
  alert(2+2);
  alert(y(10));
}

$.get({
  ajax: true,
  url: 'foo'
});
'''

let imba-code = '''
x = ->
  alert 2 + 2
  alert y(10)
  return

$.get
  ajax: true
  url: 'foo'
'''
test 'call_statement' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js