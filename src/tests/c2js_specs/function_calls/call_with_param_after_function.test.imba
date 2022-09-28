import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
setTimeout(function () {
  return work();
}, 500);
'''

let imba-code = '''
setTimeout (->
  work()
), 500
'''
test 'call_with_param_after_function' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js