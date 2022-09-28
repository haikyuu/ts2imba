import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
// hi
// there
/* world */
'''

let imba-code = '''
# hi
# there

### world ###
'''
test 'program_with_only_comments' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js