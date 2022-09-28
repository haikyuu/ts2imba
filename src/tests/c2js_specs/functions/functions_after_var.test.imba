import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
function fn() {
  var x;
  function fn2() {
    return x = 2;
  }
}
'''

let imba-code = '''
fn = ->
  x = undefined

  fn2 = ->
    x = 2

  return
'''
test 'functions_after_var' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js