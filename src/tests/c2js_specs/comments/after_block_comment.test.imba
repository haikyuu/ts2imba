import {test, expect} from "vitest"
import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
function x() {
  return y;
  /*
   * hello
   */
}
'''

let imba-code = '''
def x
	y

	###
	# hello
	###
'''
test 'after_block_comment' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js