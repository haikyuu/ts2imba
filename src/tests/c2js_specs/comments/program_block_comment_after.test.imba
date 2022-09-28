import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
a();
/*
 * hello
 */
'''

test 'program_block_comment_after 44' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')