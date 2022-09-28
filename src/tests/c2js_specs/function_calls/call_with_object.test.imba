import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
box.on('click', { silent: true }, function () {
  return go();
})
'''

let imba-code = '''
box.on 'click', { silent: true }, ->
  go()
'''
test 'call_with_object' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js