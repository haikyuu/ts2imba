import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
delete a[x];
'''

let imba-code = '''
delete a[x]
'''
test 'delete' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js