import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
a[x] = 2
'''

let imba-code = '''
a[x] = 2
'''
test 'index' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js