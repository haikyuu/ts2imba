import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
for (;;c++) {
  if (true) continue;
  if (false) continue;
}
'''

let imba-code = '''
loop
  if true
    c++
    continue
  if false
    c++
    continue
  c++
'''
test 'for_with_continue_without_init' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js