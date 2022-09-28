import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
var val = 2;
var fn = function () {
  var val = 1;
  return;
}
fn();
assert(val === 2);
'''

let imba-code = '''
val = 2

fn = ->
  `var val`
  val = 1
  return

fn()
assert val == 2
'''
test 'var_shadowing' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js