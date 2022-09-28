import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
this["#" + id]
'''

let imba-code = '''
@['#' + id]
'''
test 'index_resolution_witH_this' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js