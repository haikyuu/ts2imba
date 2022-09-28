import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
var value = ((value & 255) << 16) | (value & 65280) | ((value & 16711680) >>> 16);
'''

let imba-code = '''
value = (value & 255) << 16 | value & 65280 | (value & 16711680) >>> 16
'''
test 'bitwise_shift' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js