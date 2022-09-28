import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
switch (x) { case 2: a; break; case 3: b; break; default: x; }
switch (x) { case 2: case 3: b; break; default: x; }
'''

let imba-code = '''
switch x
  when 2
    a
  when 3
    b
  else
    x
switch x
  when 2, 3
    b
  else
    x
'''
test 'switch' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js