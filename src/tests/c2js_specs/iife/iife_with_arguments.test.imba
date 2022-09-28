import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
(function(jQuery){ return true; })(jQuery)
'''

let imba-code = '''
do (jQuery) ->
  true
'''
test 'iife_with_arguments' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js