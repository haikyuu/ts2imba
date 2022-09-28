import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
$("#foo").css({ opacity: 0 }).css({ left: 0, right: 0 }).highlight().animate({ opacity: 1 });
$("#foo").css({ opacity: 0 }).css({ left: 0, right: 0 }).highlight().animate({ opacity: 1, left: 20 }, 3);
'''

let imba-code = '''
$("#foo").css(opacity: 0).css(
  left: 0
  right: 0
).highlight().animate opacity: 1
$("#foo").css(opacity: 0).css(
  left: 0
  right: 0
).highlight().animate
  opacity: 1
  left: 20
, 3
'''
test 'function_chaining' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js