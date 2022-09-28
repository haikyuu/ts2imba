import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
function ifNullChecks() {
  if (x===null) { yep() }
  return
}
'''

let imba-code = '''
ifNullChecks = ->
  if x == null
    yep()
  return
'''
test 'null_check' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js