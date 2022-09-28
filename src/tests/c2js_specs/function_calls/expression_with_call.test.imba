import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
(function () {
  return go();
}).call(this);
'''

let imba-code = '''
(->
  go()
).call this
'''
test 'expression_with_call' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js