import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
if (a === function(){ return x(); }) {
  b()
  c()
}
'''

let imba-code = '''
if a == (->
    x()
  )
  b()
  c()
'''
test 'escaping_if_functions' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js