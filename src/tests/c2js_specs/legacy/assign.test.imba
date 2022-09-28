import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
a = 2;
a += 1;
a -= 1;
a *= 4;
a /= 2;
a %= 0;
a <<= 0;
a ^= 0;
'''

let imba-code = '''
a = 2
a += 1
a -= 1
a *= 4
a /= 2
a %= 0
a <<= 0
a ^= 0
'''
test 'assign' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js