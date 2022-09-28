import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
a();
/*
 * hello
 */
'''

let imba-code = '''
a()

###
# hello
###
'''
test 'program_block_comment_after' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js