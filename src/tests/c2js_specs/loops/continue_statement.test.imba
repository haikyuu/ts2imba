import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
while (condition) {
  if (x) continue;
  a();
}
'''

let imba-code = '''
while condition
  if x
    continue
  a()
'''
test 'continue_statement' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js