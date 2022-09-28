import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
for (a; b; update++) {
  if (x) continue;
  d()
}
'''

let imba-code = '''
a
while b
  if x
    update++
    continue
  d()
  update++
'''
test 'for_with_continue' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js