import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
var a = -1.21e3;
'''

let imba-code = '''
a = -1.21e3
'''
test 'scientific_notation' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js