import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
({
  a: function () {
    function b() { return c; }
    return b()
  }
})
'''

let imba-code = '''
a: ->

  b = ->
    c

  b()
'''
test 'nested_functions_in_object' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js