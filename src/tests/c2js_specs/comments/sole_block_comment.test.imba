import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
function fn() {
  /*
   * hello
   */
}
'''

let imba-code = '''
fn = ->

  ###
  # hello
  ###

  return
'''
test 'sole_block_comment' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js