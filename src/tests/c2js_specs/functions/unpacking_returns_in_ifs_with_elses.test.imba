import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
function a() {
  if (x)
    return b();
  else if (y)
    return c();
  else
    return d();
}
'''

let imba-code = '''
a = ->
  if x
    b()
  else if y
    c()
  else
    d()
'''
test 'unpacking_returns_in_ifs_with_elses' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js