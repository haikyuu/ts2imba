import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
hello(); // there
world();
'''

let imba-code = '''
hello()
# there
world()
'''
test 'trailing_line_comment' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js