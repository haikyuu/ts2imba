import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
if (x) {
  /**
   * documentation here
   */
  y();
}
'''

let imba-code = '''
if x

  ###*
  # documentation here
  ###

  y()
'''
test 'indented_jsdoc_comments' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js