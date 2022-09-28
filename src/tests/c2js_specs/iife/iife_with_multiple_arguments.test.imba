import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
(function(jQuery, window){ return true; })(jQuery, window)
'''

let imba-code = '''
do (jQuery, window) ->
  true
'''
test 'iife_with_multiple_arguments' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js