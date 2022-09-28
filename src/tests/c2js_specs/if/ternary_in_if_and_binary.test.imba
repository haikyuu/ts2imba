import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
if (x && (a ? b : c)) { d(); }
'''

let imba-code = '''
if x and (if a then b else c)
  d()
'''
test 'ternary_in_if_and_binary' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js