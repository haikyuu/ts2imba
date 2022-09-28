import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
a(); /* hi */
b();
'''

let imba-code = '''
a()

### hi ###

b()
'''
test 'block_comments_with_space 1' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')