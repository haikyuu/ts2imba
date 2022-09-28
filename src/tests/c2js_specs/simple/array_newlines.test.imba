import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
controller('name', [
  'a',
  'b',
  function (a, b) {
    alert('ok');
    return;
  },
  'z'
]);
'''

let imba-code = '''
controller 'name', [
  'a'
  'b'
  (a, b) ->
    alert 'ok'
    return
  'z'
]
'''
test 'array_newlines' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js