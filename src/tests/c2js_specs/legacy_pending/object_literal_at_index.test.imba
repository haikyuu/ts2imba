import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
var o = {}

o[{a: 1, b: 2}] = 3

o[{c: 4}] = 5
'''

let imba-code = '''
o = {}
o[{
  a: 1
  b: 2
}] = 3
o[c: 4] = 5
'''
test 'object_literal_at_index' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js