import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
a();
/*
 * hello
 */
b();
'''

let imba-code = '''
a()

###
# hello
###

b()
'''
test 'block_comments' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js