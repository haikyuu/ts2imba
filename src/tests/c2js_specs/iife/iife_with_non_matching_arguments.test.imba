import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
(function () {
  return true
})(a);
'''

let imba-code = '''
(->
  true
) a
'''
test 'iife_with_non_matching_arguments' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js