import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
/*
 * hello
 */
a();
'''

let imba-code = '''
###
# hello
###

a()
'''
test 'program_block_comment_before' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js