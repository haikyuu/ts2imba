import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
a();
// hello
b();
'''

let imba-code = '''
a()
# hello
b()
'''
test 'line_comments' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js