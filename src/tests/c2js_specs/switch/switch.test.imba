import {test, expect} from "vitest"
import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
switch (obj) {
  case 'one':
    a();
    break;
  case 'two':
    b();
    break;
  default:
    c();
}
'''

let imba-code = '''
switch obj
  when 'one'
    a()
  when 'two'
    b()
  else
    c()
'''
test 'switch' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js