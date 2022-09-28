import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
function greet(name = 'Bob', age) {
  return name;
}
'''

test 'mixed_params_2 1112' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')