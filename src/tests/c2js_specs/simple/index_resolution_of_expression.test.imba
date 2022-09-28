import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
a["node" + n]
'''

let imba-code = '''
a['node' + n]
'''
test 'index_resolution_of_expression' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js