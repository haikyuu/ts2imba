import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
while (something) { foo(); }
while (something) { foo(); bar(); }
while (!something) { foo(); }
while (!something) { foo(); bar(); }
'''

let imba-code = '''
foo()  while something
while something
  foo()
  bar()
foo()  until something
until something
  foo()
  bar()
'''
test 'single_line_while' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js