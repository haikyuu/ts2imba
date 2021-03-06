import {test, expect} from "vitest"
import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
function greet(name = 'Bob', age) {
  return name;
}
'''

let imba-code = '''
greet = (name = 'Bob', age) ->
  name
'''
test 'mixed_params_2' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js