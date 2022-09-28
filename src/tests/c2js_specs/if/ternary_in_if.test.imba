import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
if (a ? b : c) { d(); }
'''

let imba-code = '''
if (if a then b else c)
  d()
'''
test 'ternary_in_if' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js