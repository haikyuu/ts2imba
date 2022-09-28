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

test 'after_block_comment 1' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')