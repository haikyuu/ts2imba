import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
function greet(name = 'Bob') {
  return name;
}
'''

let imba-code = '''
greet = (name = 'Bob') ->
  name
'''
test 'with_defaults' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js