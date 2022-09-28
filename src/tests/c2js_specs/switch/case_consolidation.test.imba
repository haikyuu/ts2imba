import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
switch (a) {
  case one:
  case two:
    b();
    break;
  default:
    c();
}
'''

let imba-code = '''
switch a
  when one, two
    b()
  else
    c()
'''
test 'case_consolidation' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js