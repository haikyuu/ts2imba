import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
function fn() {
  if (a) { b(); }
  else if (b) { c(); }
  else { d(); }
  return;
}
'''

let imba-code = '''
fn = ->
  if a
    b()
  else if b
    c()
  else
    d()
  return
'''
test 'if_with_else_if_inside_functions' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js