import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
for (var i = 0; i < xxxxx; i++) {
  action();
}
'''

let imba-code = '''
for i in [0...xxxxx]
  action()
'''
test 'simple_for_loop' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js