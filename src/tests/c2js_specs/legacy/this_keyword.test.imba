import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
(function() {
  return this;
})
'''

let imba-code = '''
->
  this
'''
test 'this_keyword' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js