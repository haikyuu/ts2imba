import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
do {
  b();
} while (a)
'''

let imba-code = '''
loop
  b()
  unless a
    break
'''
test 'do_while' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js