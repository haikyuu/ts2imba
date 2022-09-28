import {build} from "../../../index"
import * as imbac from 'imba/compiler'

let tsx-code = '''
function greet(name = 'Bob') {
  return name;
}
'''

test 'with_defaults 33' do
	const result = await build tsx-code
	expect(result.code).toMatchSnapshot()
	const out = imbac.compile(result.code, sourceId: 'sth')