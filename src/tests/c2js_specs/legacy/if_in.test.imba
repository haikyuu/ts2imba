import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
if (key in obj)
    single_liner()
'''

let imba-code = '''
if key of obj
  single_liner()
'''
test 'if_in' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js