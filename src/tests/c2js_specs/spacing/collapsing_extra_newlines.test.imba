import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
/*
 * hello
 */
/*
 * world
 */
'''

let imba-code = '''
###
# hello
###

###
# world
###
'''
test 'collapsing_extra_newlines' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js