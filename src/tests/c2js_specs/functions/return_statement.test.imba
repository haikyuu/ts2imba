import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
function a () {
  if (x) return b;
  return c;
}
'''

let imba-code = '''
a = ->
  if x
    return b
  c
'''
test 'return_statement' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js