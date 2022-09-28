import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
/=/g
'''

let imba-code = '''
RegExp '=', 'g'
'''
test 'equals_with_flag' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js