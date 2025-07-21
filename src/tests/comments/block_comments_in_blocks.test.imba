import {build} from "../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
if (x) {
  /*
   * hello
   * world
   */
  y();
}
'''

test 'block_comments_in_blocks' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	expect(out.js).toBeDefined()
