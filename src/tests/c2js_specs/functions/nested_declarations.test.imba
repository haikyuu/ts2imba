import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
function a () {
  function b () {
    return c;
  }
}
'''

let imba-code = '''
a = ->

  b = ->
    c

  return
'''
test 'nested_declarations' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js