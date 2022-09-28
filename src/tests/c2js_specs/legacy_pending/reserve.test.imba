import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
var off = false
foo(off)

// STRICT_PROSCRIBED
eval('off')
arguments
'''

let imba-code = '''
off_ = false
foo off_
eval "off"
arguments
'''
test 'reserve' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js