import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
if (x) throw e
'''

let imba-code = '''
if x
  throw e
'''
test 'indented_throw' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js