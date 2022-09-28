import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
if (true) {
  for (a;b;c) { d; }
}
'''

let imba-code = '''
if true
  a
  while b
    d
    c
'''
test 'indented_for' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js