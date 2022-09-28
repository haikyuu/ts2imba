import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
function fn () {
  switch (obj) {
    case 'one':
      return a();
    default:
      return b();
  }
  return
}
'''

let imba-code = '''
fn = ->
  switch obj
    when 'one'
      return a()
    else
      return b()
  return
'''
test 'switch_with_return' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js