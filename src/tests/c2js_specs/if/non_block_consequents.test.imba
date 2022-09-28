import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
function fn() {
  if (a) b();
  else c();
  return;
}
'''

let imba-code = '''
fn = ->
  if a
    b()
  else
    c()
  return
'''
test 'non_block_consequents' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js