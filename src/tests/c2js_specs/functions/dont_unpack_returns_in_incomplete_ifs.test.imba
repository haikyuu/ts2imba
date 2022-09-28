import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
function a() {
  if (x)
    return b();
  else
    c();
}
'''

let imba-code = '''
a = ->
  if x
    return b()
  else
    c()
  return
'''
test 'dont_unpack_returns_in_incomplete_ifs' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js