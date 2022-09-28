import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
switch (obj) {
  // test
  case 'one':
    // test
    a();
    break;
  // test
  case 'two':
    // test
    b();
    break;
  default:
    c();
}
'''

let imba-code = '''
switch obj
  # test
  when 'one'
    # test
    a()
  # test
  when 'two'
    # test
    b()
  else
    c()
'''
test 'switch_with_comments' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js