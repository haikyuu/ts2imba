import {test, expect} from "vitest"
import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
call(function (undefined) {
  return true;
});
'''

let imba-code = '''
call ->
  true
'''
test 'undefined_in_function_expression_parameters' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js