import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
box.on('click', function () {
  return go();
}, { delay: 500, silent: true })
'''

let imba-code = '''
box.on 'click', (->
  go()
),
  delay: 500
  silent: true
'''
test 'call_with_function_then_object' do
	const result = await build tsx-code
	expect(result.code).toEqual(imba-code)
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js