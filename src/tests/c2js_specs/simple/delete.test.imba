import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
delete x.y;
'''

let imba-code = '''
delete x.y
'''
test 'delete' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js