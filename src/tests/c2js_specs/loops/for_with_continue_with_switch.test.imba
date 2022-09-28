import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
for (a; b; update++) {
  switch (x) {
    case 1:
      continue;
      break;
  }
  d()
}
'''

let imba-code = '''
a
while b
  switch x
    when 1
      update++
      continue
  d()
  update++
'''
test 'for_with_continue_with_switch' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js