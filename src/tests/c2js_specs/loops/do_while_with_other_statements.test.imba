import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
function fn() {
  before();
  do {
    b();
  } while (a);
  after();
  return;
}
'''

let imba-code = '''
fn = ->
  before()
  loop
    b()
    unless a
      break
  after()
  return
'''
test 'do_while_with_other_statements' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js