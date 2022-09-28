import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
var char = '\x1b'
'''

let imba-code = '''
char = 'u\001b'
'''
test 'special_characters' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js