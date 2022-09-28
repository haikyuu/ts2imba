import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
var x = ({a: {b: {c: {d: e}}, f: {g: {h: i}}}})
'''

let imba-code = '''
x = a:
  b: c: d: e
  f: g: h: i
'''
test 'nesting_into_a_single_line' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js