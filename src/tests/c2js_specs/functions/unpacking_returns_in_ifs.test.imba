import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
function a() {
  if (x)
    return b();
  else
    return c();
}
'''

let imba-code = '''
a = ->
  if x
    b()
  else
    c()
'''
test 'unpacking_returns_in_ifs' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js