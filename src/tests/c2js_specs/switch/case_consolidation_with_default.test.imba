import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
switch (a) {
  case one:
    b();
    break;
  case two:
  default:
    c();
}
'''

let imba-code = '''
switch a
  when one
    b()
  else
    c()
'''
test 'case_consolidation_with_default' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js