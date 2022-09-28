import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
(function () {
  return true
})(2);
'''

let imba-code = '''
(->
  true
) 2
'''
test 'iife_with_non_matching_literal_arguments' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js