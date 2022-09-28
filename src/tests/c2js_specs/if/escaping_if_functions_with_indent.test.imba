import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
if (1) {
  if (2) {
    if (3) {
      if (a === function(){ return x(); }) {
        b()
        c()
      }
    }
  }
}
'''

let imba-code = '''
if 1
  if 2
    if 3
      if a == (->
          x()
        )
        b()
        c()
'''
test 'escaping_if_functions_with_indent' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js