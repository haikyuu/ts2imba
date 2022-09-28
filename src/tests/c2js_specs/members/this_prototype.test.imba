import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
this.prototype.a = 1;
'''

let imba-code = '''
@::a = 1
'''
test 'this_prototype' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js