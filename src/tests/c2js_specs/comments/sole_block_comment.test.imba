import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
function fn() {
  /*
   * hello
   */
}
'''

test 'sole_block_comment 444' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')