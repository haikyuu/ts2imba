import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
++a;
--b;
'''

let imba-code = '''
++a
--b
'''
test 'prefix_increment' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js