import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
on = 2
'''

let imba-code = '''

'''
test 'assignment_of_reserved_words_off' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js