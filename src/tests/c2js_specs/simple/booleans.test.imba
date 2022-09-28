import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
true;
false;
'''

let imba-code = '''
true
false
'''
test 'booleans' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js