import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
'\u2028'
'\u2029'
'''

let imba-code = '''
'\u2028'
'\u2029'
'''
test 'unicode' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js