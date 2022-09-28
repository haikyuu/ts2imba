import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
function returns() {
  if (x) {
    if (y) {
      return y
    } else {
      return x
    }
  } else {
    return z
  }
}
'''

let imba-code = '''
returns = ->
  if x
    if y
      y
    else
      x
  else
    z
'''
test 'unpacking_returns_in_nested_ifs' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js