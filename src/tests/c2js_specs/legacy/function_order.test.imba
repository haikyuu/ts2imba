import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
var x = function() {
    alert(y());
    var z = function() { return 3; }
    function y() { return 2; }
}
'''

let imba-code = '''
x = ->

  y = ->
    2

  alert y()

  z = ->
    3

  return
'''
test 'function_order' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js