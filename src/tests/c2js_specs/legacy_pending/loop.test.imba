import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
while (true) {}
while (true) { x(); }
while (100) {}
while (100) { x(); }
while (0.0) { x(); }
while (0.01) { x(); }
'''

let imba-code = '''
loop
  continue
loop
  x()
loop
  continue
loop
  x()
x()  while 0.0
loop
  x()
'''
test 'loop' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js