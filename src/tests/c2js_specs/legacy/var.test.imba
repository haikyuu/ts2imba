import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
var x = 2;
var y;
var f = function() { return y };
'''

let imba-code = '''
x = 2
y = undefined

f = ->
  y
'''
test 'var' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js