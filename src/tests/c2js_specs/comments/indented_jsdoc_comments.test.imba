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
test 'indented_jsdoc_comments 23' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')