import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
for (x in y) {
  alert(x);
}
'''

let imba-code = '''
for x_ of y
  `x = x_`
  alert x_
'''
test 'for_in_without_var' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js