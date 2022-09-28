import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
var x = 3
var y = 2
'''

let imba-code = '''
x = 3
y = 2
'''
test 'crlf' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js