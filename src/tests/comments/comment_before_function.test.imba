import {build} from "../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
a()
/*
 * comment
 */
function x() {
  return;
}
'''

test 'comment_before_function' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	expect(out.js).toBeDefined()
