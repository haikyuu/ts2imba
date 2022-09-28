import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
({ a: 1, b: 2 });
({ c: 3, d: 4 });
'''

let imba-code = '''
{
  a: 1
  b: 2
}
c: 3
d: 4
'''
test 'multiple_object_expressions' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')
	console.log out.js