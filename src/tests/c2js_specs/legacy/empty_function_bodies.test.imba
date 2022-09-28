import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
x = { v: function() { return 2; }, y: function(){}, z: function(){} };
'''

let imba-code = '''
x =
  v: ->
    2
  y: ->
  z: ->
'''
test 'empty_function_bodies' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js