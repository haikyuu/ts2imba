import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
on = 2
'''

test 'assignment_of_reserved_words_off 1112' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')