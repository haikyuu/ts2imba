import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
for(;;){}
'''

let imba-code = '''
loop
  continue
'''
test 'for_with_no_body' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js