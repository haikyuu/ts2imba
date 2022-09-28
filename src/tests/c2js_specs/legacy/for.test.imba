import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
for (x=0; !x<2; x++) { alert(1) }
for (; !x<2; ) { alert(1) }
for (;;++x) { alert(1) }
for (;;) { alert(1) }
'''

let imba-code = '''
x = 0
while !x < 2
  alert 1
  x++
while !x < 2
  alert 1
loop
  alert 1
  ++x
loop
  alert 1
'''
test 'for' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js