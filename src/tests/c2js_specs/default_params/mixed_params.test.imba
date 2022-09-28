import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
function greet(greeting, name = 'Bob') {
  return name;
}
'''

let imba-code = '''
greet = (greeting, name = 'Bob') ->
  name
'''
test 'mixed_params' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js